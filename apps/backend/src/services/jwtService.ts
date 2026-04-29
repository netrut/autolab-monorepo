import jwt from 'jsonwebtoken';
import { env } from '../config/env';

export const jwtService = {
  generateToken(payload: {
    userId: string;
    email: string;
    role: string;
  }): string {
    return jwt.sign(payload, env.jwt.secret, {
      expiresIn: env.jwt.expiry,
    });
  },

  generateEmailVerificationToken(email: string): string {
    return jwt.sign({ email, type: 'email_verification' }, env.jwt.secret, {
      expiresIn: '24h',
    });
  },

  generatePasswordResetToken(email: string): string {
    return jwt.sign({ email, type: 'password_reset' }, env.jwt.secret, {
      expiresIn: '1h',
    });
  },

  verifyToken(token: string): any {
    try {
      return jwt.verify(token, env.jwt.secret);
    } catch (error) {
      throw new Error('Invalid or expired token');
    }
  },
};