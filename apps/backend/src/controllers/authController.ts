import { Request, Response } from 'express';
import bcryptjs from 'bcryptjs';
import { jwtService } from '../services/jwtService.js';
import { emailService } from '../services/emailService.js';
import { smsService } from '../services/smsService.js';
import { v4 as uuidv4 } from 'uuid';
import prisma from '../config/prisma.js';


// Store OTPs in memory (in production use Redis)
const otpStore: Map<string, { otp: string; expiresAt: number }> = new Map();

export const authController = {
  // User registration
  async register(req: Request, res: Response) {
    try {
      const { email, phone, password, name } = req.body;

      // Check if user exists
      const existingUser = await prisma.user.findFirst({
        where: { OR: [{ email }, { phone_number: phone }] },
      });

      if (existingUser) {
        return res.status(400).json({ error: 'User already exists' });
      }

      // Hash password
      const hashedPassword = await bcryptjs.hash(password, 10);

      // Create user
      const user = await prisma.user.create({
        data: {
          email,
          phone_number: phone,
          password_hash: hashedPassword,
          display_name: name,
          is_active: false,
        },
      });

      // Send verification email
      const verificationToken = jwtService.generateEmailVerificationToken(email);
      const verificationLink = `${process.env.API_URL}/api/auth/verify-email?token=${verificationToken}`;

      try {
        await emailService.sendVerificationEmail(email, verificationLink);
      } catch (emailError) {
        if (process.env.NODE_ENV === 'development') {
          console.warn('Email verification skipped in development mode:', emailError);
        } else {
          throw emailError;
        }
      }

      // Return success
      res.status(201).json({
        message: 'User registered. Check your email to verify.',
        userId: user.id,
        email: user.email,
        phone: user.phone_number,
      });
    } catch (error) {
      console.error('Registration error:', error);
      res.status(500).json({ error: 'Registration failed' });
    }
  },

  // Send OTP
  async sendOTP(req: Request, res: Response) {
    try {
      const { phone } = req.body;

      // Generate 6-digit OTP
      const otp = Math.floor(100000 + Math.random() * 900000).toString();

      // Store OTP with 10-minute expiry
      otpStore.set(phone, {
        otp,
        expiresAt: Date.now() + 10 * 60 * 1000,
      });

      // Send OTP via SMS
      await smsService.sendOTP(phone, otp);

      res.json({ message: 'OTP sent successfully' });
    } catch (error) {
      res.status(500).json({ error: 'Failed to send OTP' });
    }
  },

  // Verify OTP
  async verifyOTP(req: Request, res: Response) {
    try {
      const { phone, otp, name, email, password } = req.body;

      // Get stored OTP
      const storedOTP = otpStore.get(phone);

      if (!storedOTP || storedOTP.otp !== otp) {
        return res.status(400).json({ error: 'Invalid OTP' });
      }

      if (storedOTP.expiresAt < Date.now()) {
        return res.status(400).json({ error: 'OTP expired' });
      }

      // Hash password
      const hashedPassword = await bcryptjs.hash(password, 10);

      // Create or update user
      let user = await prisma.user.findUnique({
        where: { phone_number: phone },
      });

      if (!user) {
        user = await prisma.user.create({
          data: {
            email: email || `${phone}@autolab.com`,
            phone_number: phone,
            password_hash: hashedPassword,
            display_name: name,
          },
        });
      }

      // Generate JWT
      const token = jwtService.generateToken({
        userId: user.id,
        email: user.email,
        role: String(user.role_id || 'CUSTOMER'),
      });

      // Clear OTP
      otpStore.delete(phone);

      res.json({
        message: 'OTP verified successfully',
        token,
        user: {
          id: user.id,
          email: user.email,
          name: user.display_name,
          phone: user.phone_number,
        },
      });
    } catch (error) {
      res.status(500).json({ error: 'OTP verification failed' });
    }
  },

  // Login
  async login(req: Request, res: Response) {
    try {
      const { email, password } = req.body;

      // Find user
      const user = await prisma.user.findUnique({
        where: { email },
      });

      if (!user) {
        return res.status(401).json({ error: 'Invalid credentials' });
      }

      if (user.is_active === false) {
        return res.status(403).json({
          error: 'Please verify your email before logging in.',
        });
      }

      // Verify password
      const passwordMatch = await bcryptjs.compare(password, user.password_hash || '');

      if (!passwordMatch) {
        return res.status(401).json({ error: 'Invalid credentials' });
      }

      // Generate JWT (updated_at is automatically updated on login queries)
      const token = jwtService.generateToken({
        userId: user.id,
        email: user.email,
        role: String(user.role_id || 'CUSTOMER'),
      });

      res.json({
        message: 'Login successful',
        token,
        user: {
          id: user.id,
          email: user.email,
          name: user.display_name,
          phone: user.phone_number,
          role: user.role_id,
        },
      });
    } catch (error) {
      res.status(500).json({ error: 'Login failed' });
    }
  },

  // Verify email
  async verifyEmail(req: Request, res: Response) {
    try {
      const { token } = req.query;

      if (!token) {
        return res.status(400).json({ error: 'No token provided' });
      }

      const decoded = jwtService.verifyToken(token as string) as {
        email: string;
        type: string;
      };

      if (decoded.type !== 'email_verification') {
        return res.status(400).json({ error: 'Invalid token type' });
      }

      // Update user
      await prisma.user.update({
        where: { email: decoded.email },
        data: {
          is_active: true,
        },
      });

      res.json({ message: 'Email verified successfully' });
    } catch (error) {
      res.status(400).json({ error: 'Email verification failed' });
    }
  },

  // Forgot password
  async forgotPassword(req: Request, res: Response) {
    try {
      const { email } = req.body;

      const user = await prisma.user.findUnique({
        where: { email },
      });

      if (!user) {
        // Don't reveal if user exists
        return res.json({ message: 'If user exists, reset link sent to email' });
      }

      // Generate reset token
      const resetToken = jwtService.generatePasswordResetToken(email);
      const resetLink = `${process.env.FLUTTER_APP_URL}/?reset=${resetToken}`;

      // Send email
      await emailService.sendPasswordResetEmail(email, resetLink);

      res.json({ message: 'Password reset link sent to email' });
    } catch (error) {
      res.status(500).json({ error: 'Failed to send reset link' });
    }
  },

  // Reset password
  async resetPassword(req: Request, res: Response) {
    try {
      const { token, newPassword } = req.body;

      const decoded = jwtService.verifyToken(token) as {
        email: string;
        type: string;
      };

      if (decoded.type !== 'password_reset') {
        return res.status(400).json({ error: 'Invalid token type' });
      }

      // Hash new password
      const hashedPassword = await bcryptjs.hash(newPassword, 10);

      // Update password
      await prisma.user.update({
        where: { email: decoded.email },
        data: { password_hash: hashedPassword },
      });

      res.json({ message: 'Password reset successfully' });
    } catch (error) {
      res.status(400).json({ error: 'Password reset failed' });
    }
  },
};