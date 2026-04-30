import jwt, { SignOptions } from 'jsonwebtoken';
import { env } from '../config/env.js';

export const jwtService = {
  generateToken(payload: {
    userId: string;
    email: string;
    role: string;
  }): string {
    return jwt.sign(payload, env.jwt.secret, {
      expiresIn: env.jwt.expiry,
    } as SignOptions);
  },

  generateEmailVerificationToken(email: string): string {
    const options: SignOptions = {
      expiresIn: '24h',
    };
    return jwt.sign({ email, type: 'email_verification' }, env.jwt.secret, options);
  },

  generatePasswordResetToken(email: string): string {
    const options: SignOptions = {
      expiresIn: '1h',
    };
    return jwt.sign({ email, type: 'password_reset' }, env.jwt.secret, options);
  },

  verifyToken(token: string): any {
    try {
      return jwt.verify(token, env.jwt.secret);
    } catch (error) {
      throw new Error('Invalid or expired token');
    }
  },
};