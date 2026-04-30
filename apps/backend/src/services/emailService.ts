import axios from 'axios';
import nodemailer from 'nodemailer';
import { env } from '../config/env.js';

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: env.email.gmail.user,
    pass: env.email.gmail.pass,
  },
});

export const emailService = {
  async sendVerificationEmail(to: string, verificationLink: string) {
    const html = `
      <h1>Verify Your Email</h1>
      <p>Click the link below to verify your email:</p>
      <a href="${verificationLink}">${verificationLink}</a>
      <p>This link expires in 24 hours.</p>
    `;

    await axios.post(
      'https://api.brevo.com/v3/smtp/email',
      {
        sender: {
          name: 'AutoLab',
          email: env.email.gmail.user,
        },
        to: [{ email: to }],
        subject: 'Verify Your AutoLab Account',
        htmlContent: html,
      },
      {
        headers: {
          'api-key': env.email.bravo.apiKey,
          'content-type': 'application/json',
          accept: 'application/json',
        },
      }
    );
  },

  async sendPasswordResetEmail(to: string, resetLink: string) {
    const html = `
      <h1>Reset Your Password</h1>
      <p>Click the link below to reset your password:</p>
      <a href="${resetLink}">${resetLink}</a>
      <p>This link expires in 1 hour.</p>
    `;

    await transporter.sendMail({
      from: env.email.gmail.user,
      to,
      subject: 'Reset Your AutoLab Password',
      html,
    });
  },

  async sendBookingConfirmation(
    to: string,
    bookingId: string,
    serviceName: string,
    date: string
  ) {
    const html = `
      <h1>Booking Confirmed!</h1>
      <p>Your service booking has been confirmed.</p>
      <ul>
        <li>Booking ID: ${bookingId}</li>
        <li>Service: ${serviceName}</li>
        <li>Date: ${date}</li>
      </ul>
      <p>Thank you for using AutoLab!</p>
    `;

    await transporter.sendMail({
      from: env.email.gmail.user,
      to,
      subject: 'Booking Confirmation',
      html,
    });
  },
};