import sendgrid
import json
from sendgrid.helpers.mail import Mail, Email, To, Content

sendmail(apikey,frommail,tomails,typing,subject,body):
    sg = sendgrid.SendGridAPIClient(api_key=apikey)
    from_email = Email(frommail)  
    tomail = tomails.split(",")
    to_email = tomail
    content = Content(f"text/{typing}", body )
    mail = Mail(from_email, to_email, subject, content)

    # Get a JSON-ready representation of the Mail object
    mail_json = mail.get()

    # Send an HTTP POST request to /mail/send
    response = sg.client.mail.send.post(request_body=mail_json)
    if str(response.status_code) == '202':
            print("Email sent successfully")
    else:
            print("[ERROR] Login failed with Unknown error")
            sys.exit(1)
          
sendmail(sys.argv[1].strip(),sys.argv[2].strip(),sys.argv[3].strip(),sys.argv[4].strip(),sys.argv[5].strip(),sys.argv[6].strip())
