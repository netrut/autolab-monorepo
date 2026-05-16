import axios from 'axios';
import { env } from '../config/env.js';

const BREVO_URL = 'https://api.brevo.com/v3/smtp/email';

async function sendEmail(to: string, subject: string, htmlContent: string): Promise<void> {
  await axios.post(
    BREVO_URL,
    {
      sender: {
        name: env.email.brevo.senderName,
        email: env.email.brevo.senderEmail,
      },
      to: [{ email: to }],
      subject,
      htmlContent,
    },
    {
      headers: {
        'api-key': env.email.brevo.apiKey,
        'content-type': 'application/json',
        accept: 'application/json',
      },
    }
  );
}

export const emailService = {
  async sendVerificationEmail(to: string, verificationLink: string): Promise<void> {
    const html = `
      <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;padding:24px">
        <h2 style="color:#1B1F26">Verify Your AutoLab Account</h2>
        <p>Thanks for signing up! Click the button below to verify your email address.</p>
        <a href="${verificationLink}"
           style="display:inline-block;background:#1B1F26;color:#fff;padding:12px 28px;
                  border-radius:8px;text-decoration:none;font-weight:600;margin:16px 0">
          Verify Email
        </a>
        <p style="color:#7A7A7A;font-size:13px">
          Or copy this link: <a href="${verificationLink}">${verificationLink}</a>
        </p>
        <p style="color:#7A7A7A;font-size:12px">This link expires in 24 hours.</p>
        <hr style="border:none;border-top:1px solid #eee;margin:24px 0"/>
        <p style="color:#9E9E9E;font-size:12px">AutoLab — Vehicle Service Management</p>
      </div>
    `;
    await sendEmail(to, 'Verify Your AutoLab Account', html);
  },

  async sendPasswordResetEmail(to: string, resetLink: string): Promise<void> {
    const html = `
      <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;padding:24px">
        <h2 style="color:#1B1F26">Reset Your Password</h2>
        <p>We received a request to reset your AutoLab password. Click the button below.</p>
        <a href="${resetLink}"
           style="display:inline-block;background:#1B1F26;color:#fff;padding:12px 28px;
                  border-radius:8px;text-decoration:none;font-weight:600;margin:16px 0">
          Reset Password
        </a>
        <p style="color:#7A7A7A;font-size:13px">
          Or copy this link: <a href="${resetLink}">${resetLink}</a>
        </p>
        <p style="color:#7A7A7A;font-size:12px">This link expires in 1 hour. If you didn't request this, ignore this email.</p>
        <hr style="border:none;border-top:1px solid #eee;margin:24px 0"/>
        <p style="color:#9E9E9E;font-size:12px">AutoLab — Vehicle Service Management</p>
      </div>
    `;
    await sendEmail(to, 'Reset Your AutoLab Password', html);
  },

  async sendBookingConfirmation(
    to: string,
    bookingId: string,
    serviceName: string,
    date: string
  ): Promise<void> {
    const html = `
      <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;padding:24px">
        <h2 style="color:#1B1F26">Booking Confirmed!</h2>
        <p>Your service booking has been confirmed.</p>
        <table style="width:100%;border-collapse:collapse;margin:16px 0">
          <tr><td style="padding:8px;color:#7A7A7A">Booking ID</td><td style="padding:8px;font-weight:600">${bookingId}</td></tr>
          <tr><td style="padding:8px;color:#7A7A7A">Service</td><td style="padding:8px;font-weight:600">${serviceName}</td></tr>
          <tr><td style="padding:8px;color:#7A7A7A">Date</td><td style="padding:8px;font-weight:600">${date}</td></tr>
        </table>
        <p>Thank you for using AutoLab!</p>
        <hr style="border:none;border-top:1px solid #eee;margin:24px 0"/>
        <p style="color:#9E9E9E;font-size:12px">AutoLab — Vehicle Service Management</p>
      </div>
    `;
    await sendEmail(to, 'Booking Confirmation — AutoLab', html);
  },
};
