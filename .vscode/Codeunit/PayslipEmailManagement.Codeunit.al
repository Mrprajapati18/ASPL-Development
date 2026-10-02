codeunit 60000 "Payslip Email Management"
{
    procedure SendEmailToEmployee(EmployeeRec: Record Employee)
    var
        HRMail: Text;
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        EmailSubject: Text;
        EmailBody: Text;
        SalaryMonth: Date;
        EmployeeEmail: Text[80];
        SalaryMonthText: Text[50];
    begin
        if EmployeeRec."No." = '' then
            Error('Employee No. is required.');

        EmployeeEmail := EmployeeRec."Company E-Mail";
        if EmployeeEmail = '' then
            EmployeeEmail := EmployeeRec."E-Mail";

        if EmployeeEmail = '' then
            Error('No email address found for employee %1 %2.', EmployeeRec."No.", EmployeeRec.FullName());

        HRMail := 'hr@atisunya.co';
        SalaryMonth := CalcDate('<CM>', Today);
        SalaryMonthText := Format(SalaryMonth, 0, '<Month Text> <Year4>');
        EmailSubject := StrSubstNo('Salary Slip for %1', SalaryMonthText);

        EmailBody := StrSubstNo(
            '<div style="font-family:Segoe UI,Arial,sans-serif;color:#242424;line-height:1.6;max-width:600px;margin:0 auto;padding:24px;">' +
            '<p>Dear %1,</p>' +
            '<p>Greetings from the HR Department.</p>' +
            '<p>Please find attached your <strong>Salary Slip for the month of %2</strong> for your reference and records.</p>' +
            '<p>We request you to kindly review the attached salary slip. Should you have any questions or require any further assistance, please feel free to contact the HR Department.</p>' +
            '<p>Thank you.</p>' +
            '<p>Regards,<br><strong>HR Department</strong></p>' +
            '</div>',
            EmployeeRec.FullName(), SalaryMonthText);

        Clear(EmailMessage);
        EmailMessage.Create(HRMail, EmailSubject, EmailBody, true);
        EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, EmployeeEmail);

        if not Email.Send(EmailMessage) then
            Error('Failed to send email.');
    end;

    procedure SendSalarySlipReportToEmployee(EmployeeRec: Record Employee; RequestPageParameters: Text)
    var
        LastError: Text;
        RecipientEmail: Text[80];
        HRMail: Text[80];
        SalaryMonthText: Text[50];
    begin
        HRMail := 'hr@atisunya.co';
        SalaryMonthText := Format(CalcDate('<CM>', Today), 0, '<Month Text> <Year4>');
        EmployeeRec.Get(EmployeeRec."No.");
        EmployeeRec."Salary Slip Email Status" := EmployeeRec."Salary Slip Email Status"::Pending;
        EmployeeRec."Salary Slip Status Date" := CurrentDateTime;
        EmployeeRec."Salary Slip Status Message" := 'Salary slip email is being processed.';
        EmployeeRec.Modify(true);

        RecipientEmail := EmployeeRec."Company E-Mail";
        if RecipientEmail = '' then
            RecipientEmail := EmployeeRec."E-Mail";

        if RecipientEmail = '' then begin
            UpdateSalarySlipStatus(EmployeeRec, EmployeeRec."Salary Slip Email Status"::Error, 'Both Company E-Mail and E-Mail are blank.');
            Message('Salary slip email was not sent. Enter an address in Company Email or Email on the employee card.');
            exit;
        end;

        if TrySendSalarySlipReport(EmployeeRec, HRMail, RecipientEmail, RequestPageParameters) then
            UpdateSalarySlipStatus(EmployeeRec, EmployeeRec."Salary Slip Email Status"::Sent, StrSubstNo('Salary slip for %1 emailed successfully.', SalaryMonthText))
        else begin
            LastError := GetLastErrorText();
            UpdateSalarySlipStatus(EmployeeRec, EmployeeRec."Salary Slip Email Status"::Error, CopyStr(LastError, 1, 250));
            Message('Salary slip email failed: %1', LastError);
        end;
    end;

    [TryFunction]
    local procedure TrySendSalarySlipReport(EmployeeRec: Record Employee; HRMail: Text[80]; RecipientEmail: Text[80]; RequestPageParameters: Text)
    var
        Email: Codeunit Email;
        EmailAccount: Codeunit "Email Account";
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        RecRef: RecordRef;
        FileName: Text;
    begin
        if not EmailAccount.IsAnyAccountRegistered() then
            Error('No email account is configured in Business Central. Configure an account in Email Accounts before sending payslips.');

        EmailMessage.Create(
            HRMail,
            StrSubstNo('Salary Slip for %1 - %2', Format(CalcDate('<CM>', Today), 0, '<Month Text> <Year4>'), EmployeeRec.FullName()),
            StrSubstNo(
                '<div style="font-family:Segoe UI,Arial,sans-serif;color:#242424;line-height:1.6;max-width:600px;margin:0 auto;padding:24px;">' +
                '<p>Dear %1,</p>' +
                '<p>Greetings from the HR Department.</p>' +
                '<p>Please find attached your <strong>Salary Slip for the month of %2</strong> for your reference and records.</p>' +
                '<p>We request you to kindly review the attached salary slip. Should you have any questions or require any further assistance, please feel free to contact the HR Department.</p>' +
                '<p>Thank you.</p>' +
                '<p>Regards,<br><strong>HR Department</strong></p>' +
                '</div>',
                EmployeeRec.FullName(),
                Format(CalcDate('<CM>', Today), 0, '<Month Text> <Year4>'),
                HRMail),
            true);
        EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, RecipientEmail);

        TempBlob.CreateOutStream(OutStr);
        RecRef.GetTable(EmployeeRec);
        Report.SaveAs(Report::"Salary Slip", RequestPageParameters, ReportFormat::Pdf, OutStr, RecRef);
        TempBlob.CreateInStream(InStr);
        FileName := StrSubstNo('SalarySlip_%1.pdf', EmployeeRec."No.");
        EmailMessage.AddAttachment(FileName, 'application/pdf', InStr);

        if not Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            Error('Business Central could not send the email using the Default email scenario. Verify that a valid email account is assigned to the Default scenario in Email Scenario Setup and test that account.');
    end;

    local procedure UpdateSalarySlipStatus(var EmployeeRec: Record Employee; NewStatus: Option Pending,Sent,Error; StatusMessage: Text)
    begin
        EmployeeRec."Salary Slip Email Status" := NewStatus;
        EmployeeRec."Salary Slip Status Date" := CurrentDateTime;
        EmployeeRec."Salary Slip Status Message" := CopyStr(StatusMessage, 1, MaxStrLen(EmployeeRec."Salary Slip Status Message"));
        EmployeeRec.Modify(true);
    end;
}
