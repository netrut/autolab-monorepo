import { Request, Response } from 'express';
import bcryptjs from 'bcryptjs';
import { jwtService } from '../services/jwtService.js';
import { emailService } from '../services/emailService.js';
import { smsService } from '../services/smsService.js';
import { createNotification } from '../services/notificationService.js';
import { v4 as uuidv4 } from 'uuid';
import prisma from '../config/prisma.js';


// Store OTPs in memory (in production use Redis)
const otpStore: Map<string, { otp: string; expiresAt: number }> = new Map();

const ROLE_SERVICE_CENTER_OWNER = 2;
const ROLE_CUSTOMER = 3;

function normalizeRoleId(roleId: unknown): number {
  const parsed = Number(roleId);
  return Number.isFinite(parsed) ? parsed : ROLE_CUSTOMER;
}

function getWelcomeNotification(roleId: number) {
  if (roleId === ROLE_SERVICE_CENTER_OWNER) {
    return {
      title: 'Welcome to AutoLab! 🎉',
      body: 'Your service centre account is ready. Complete your profile, add your services, and start receiving bookings.',
    };
  }

  return {
    title: 'Welcome to AutoLab! 🎉',
    body: 'Get the right service from the right service centre, book with confidence, and manage your vehicle services easily.',
  };
}

export const authController = {
  // User registration
  async register(req: Request, res: Response) {
    try {
      const { email, phone, password, name, role_id } = req.body;
      const resolvedRoleId = normalizeRoleId(role_id);

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
          role_id: resolvedRoleId,
          is_active: false,
        },
      });

      // Send verification email (non-fatal — app works even if email fails)
      const verificationToken = jwtService.generateEmailVerificationToken(email);
      const verificationLink = `${process.env.API_URL}/api/auth/verify-email?token=${verificationToken}`;
      try {
        await emailService.sendVerificationEmail(email, verificationLink);
        console.log('[Auth] Verification email sent to', email);
      } catch (emailError) {
        console.warn('[Auth] Email send failed (non-fatal):', (emailError as Error).message);
        // Auto-activate user so they can login even without email verification
        await prisma.user.update({ where: { id: user.id }, data: { is_active: true } });
      }

      // Send welcome notification
      try {
        const welcomeNotification = getWelcomeNotification(resolvedRoleId);
        await createNotification({
          userId: user.id,
          type: 'system',
          title: welcomeNotification.title,
          body: welcomeNotification.body,
        });
      } catch (_) {
        // non-fatal
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
      const { phone, otp, name, email, password, role_id } = req.body;
      const resolvedRoleId = normalizeRoleId(role_id);

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
            role_id: resolvedRoleId,
          },
        });

        // Send welcome notification for new user
        try {
          const welcomeNotification = getWelcomeNotification(resolvedRoleId);
          await createNotification({
            userId: user.id,
            type: 'system',
            title: welcomeNotification.title,
            body: welcomeNotification.body,
          });
        } catch (_) {
          // non-fatal
        }
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
          error: 'email_not_verified',
          message: 'Please verify your email before logging in.',
          email: user.email,
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

      const user = await prisma.user.findUnique({ where: { email } });

      if (!user) {
        // Don't reveal if user exists
        return res.json({ message: 'If user exists, reset link sent to email' });
      }

      // Generate reset token
      const resetToken = jwtService.generatePasswordResetToken(email);
      const resetLink = `${process.env.FLUTTER_APP_URL}/?reset=${resetToken}`;

      try {
        await emailService.sendPasswordResetEmail(email, resetLink);
        console.log('[Auth] Password reset email sent to', email);
      } catch (emailError) {
        console.warn('[Auth] Password reset email failed (non-fatal):', (emailError as Error).message);
        // Still return success — log the reset link for manual use in dev
        console.log('[Auth] Reset link (manual):', resetLink);
      }

      res.json({ message: 'If user exists, reset link sent to email' });
    } catch (error) {
      console.error('Forgot password error:', error);
      res.status(500).json({ error: 'Failed to process request' });
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

  // Resend verification email
  async resendVerification(req: Request, res: Response) {
    try {
      const { email } = req.body;
      if (!email) return res.status(400).json({ error: 'Email is required' });

      const user = await prisma.user.findUnique({ where: { email } });
      if (!user) return res.json({ message: 'If user exists, verification email sent' });
      if (user.is_active) return res.json({ message: 'Email already verified' });

      const verificationToken = jwtService.generateEmailVerificationToken(email);
      const verificationLink = `${process.env.API_URL}/api/auth/verify-email?token=${verificationToken}`;

      try {
        await emailService.sendVerificationEmail(email, verificationLink);
        console.log('[Auth] Resent verification email to', email);
      } catch (emailError) {
        console.warn('[Auth] Resend email failed:', (emailError as Error).message);
        // Auto-activate as fallback when email service is down
        await prisma.user.update({ where: { id: user.id }, data: { is_active: true } });
        return res.json({ message: 'Email service unavailable. Your account has been activated. Please login.' });
      }

      res.json({ message: 'Verification email sent. Please check your inbox.' });
    } catch (error) {
      res.status(500).json({ error: 'Failed to resend verification email' });
    }
  },

  // Change password (authenticated)
  async changePassword(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.userId;
      const { current_password, new_password } = req.body;

      if (!current_password || !new_password) {
        return res.status(400).json({ error: 'Current and new password are required' });
      }
      if (new_password.length < 6) {
        return res.status(400).json({ error: 'New password must be at least 6 characters' });
      }

      const user = await prisma.user.findUnique({ where: { id: userId } });
      if (!user?.password_hash) {
        return res.status(400).json({ error: 'No password set for this account' });
      }

      const valid = await bcryptjs.compare(current_password, user.password_hash);
      if (!valid) {
        return res.status(400).json({ error: 'Current password is incorrect' });
      }

      const hash = await bcryptjs.hash(new_password, 10);
      await prisma.user.update({ where: { id: userId }, data: { password_hash: hash } });

      res.json({ message: 'Password changed successfully' });
    } catch (error) {
      res.status(500).json({ error: 'Failed to change password' });
    }
  },

  // Delete account (soft-delete)
  async deleteAccount(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.userId;
      const { password } = req.body;

      const user = await prisma.user.findUnique({ where: { id: userId } });
      if (!user) return res.status(404).json({ error: 'User not found' });

      // Verify password if user has one
      if (user.password_hash) {
        if (!password) return res.status(400).json({ error: 'Password is required to delete account' });
        const valid = await bcryptjs.compare(password, user.password_hash);
        if (!valid) return res.status(400).json({ error: 'Incorrect password' });
      }

      // Soft delete
      await prisma.user.update({
        where: { id: userId },
        data: { is_active: false, updated_at: new Date() },
      });

      res.json({ message: 'Account scheduled for deletion' });
    } catch (error) {
      res.status(500).json({ error: 'Failed to delete account' });
    }
  },
};