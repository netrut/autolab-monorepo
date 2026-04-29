import axios from 'axios';
import { env } from '../config/env';

function normalizeIndianNumber(phoneNumber: string) {
	const digits = phoneNumber.replace(/\D/g, '');

	if (digits.length === 10) {
		return `91${digits}`;
	}

	if (digits.length === 12 && digits.startsWith('91')) {
		return digits;
	}

	throw new Error('Invalid phone number format. Use 10-digit mobile or +91 format.');
}

function buildSmsApiUrl(phoneNumber: string, otp: string) {
	const phone = normalizeIndianNumber(phoneNumber);
	const message = `OTP for login HireForCare is ${otp}.`;

	return `https://sms.hspmedianetwork.com/sendSMS?username=${encodeURIComponent(env.sms.hsp.username)}&message=${encodeURIComponent(message)}&sendername=${encodeURIComponent(env.sms.hsp.senderName)}&smstype=TRANS&numbers=${phone}&apikey=${encodeURIComponent(env.sms.hsp.apiKey)}`;
}

async function sendViaHspSmsApi(smsApiUrl: string) {
	const response = await axios.get(smsApiUrl);
	const responseText = String(response.data || '').toLowerCase();

	if (response.status !== 200 || responseText.includes('error') || responseText.includes('invalid')) {
		throw new Error(`HSP SMS API rejected request: ${response.data}`);
	}
}

export const smsService = {
	async sendOTP(phoneNumber: string, otp: string) {
		const smsApiUrl = buildSmsApiUrl(phoneNumber, otp);
		await sendViaHspSmsApi(smsApiUrl);
	},

	async sendBookingNotification(
		phoneNumber: string,
		serviceName: string,
		date: string
	) {
		const phone = normalizeIndianNumber(phoneNumber);
		const message = `Your AutoLab booking for ${serviceName} on ${date} is confirmed.`;
		const smsApiUrl = `https://sms.hspmedianetwork.com/sendSMS?username=${encodeURIComponent(env.sms.hsp.username)}&message=${encodeURIComponent(message)}&sendername=${encodeURIComponent(env.sms.hsp.senderName)}&smstype=TRANS&numbers=${phone}&apikey=${encodeURIComponent(env.sms.hsp.apiKey)}`;

		await sendViaHspSmsApi(smsApiUrl);
	},
};
