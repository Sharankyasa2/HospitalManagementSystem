using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;

namespace Hospital_Management_System_WebAPI.Services
{

    public class EmailService
    {
        private readonly IConfiguration _configuration;

        // Constructor: injects configuration used for SMTP settings
        public EmailService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        // Sends an HTML email using configured SMTP settings
        public async Task SendEmailAsync(
            string toEmail,
            string subject,
            string body)
        {
            var email = new MimeMessage();

            email.From.Add(new MailboxAddress(
                _configuration["SmtpSettings:FromName"],
                _configuration["SmtpSettings:FromEmail"]));

            email.To.Add(MailboxAddress.Parse(toEmail));

            email.Subject = subject;

            email.Body = new TextPart("html")
            {
                Text = body
            };

            using var smtp = new SmtpClient();

            await smtp.ConnectAsync(
                _configuration["SmtpSettings:Host"],
                int.Parse(_configuration["SmtpSettings:Port"]!),
                SecureSocketOptions.StartTls);

            await smtp.AuthenticateAsync(
                _configuration["SmtpSettings:Username"],
                _configuration["SmtpSettings:Password"]);

            await smtp.SendAsync(email);

            await smtp.DisconnectAsync(true);
        }
    }
}
