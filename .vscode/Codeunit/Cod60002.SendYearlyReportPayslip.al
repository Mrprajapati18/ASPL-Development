codeunit 60002 "YearlyPayslipEmail Management"
{
    procedure SendYearlyPayslipToEmployee(EmployeeRec: Record Employee)
    var
        HRMail: Text;
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        EmailSubject: Text;
        EmailBody: Text;
        SalaryYear: Integer;
    begin
        if EmployeeRec."No." = '' then
            Error('Employee No. is required.');

        if EmployeeRec."E-Mail" = '' then
            Error('No email address found for employee %1 %2.', EmployeeRec."No.", EmployeeRec.FullName());

        HRMail := 'hr@atisunya.co';
        SalaryYear := Date2DMY(CalcDate('<CM>', Today), 3);

        EmailSubject := StrSubstNo('Yearly Salary Slip for %1 - %2', EmployeeRec.FullName(), SalaryYear);
        EmailBody := StrSubstNo(
           '<div style="font-family:Segoe UI,Arial,sans-serif;background:#f9f9f9;padding:24px;border-radius:8px;max-width:600px;margin:auto;">' +
           '<h2 style="color:#2d6ca2;">Yearly Salary Slip - %2</h2>' +
           '<p>Dear <b>%1</b>,</p>' +
           '<p style="margin-bottom:16px;">Please find the yearly salary slip summary for <b>%2</b>.</p>' +
           '<table style="width:100%;border-collapse:collapse;background:#fff;border-radius:6px;box-shadow:0 2px 8px #eee;margin-bottom:16px;">' +
           '<tr style="background:#eaf4fb;"><td style="padding:8px 12px;"><b>Employee Name</b></td><td style="padding:8px 12px;">%1</td></tr>' +
           '<tr><td style="padding:8px 12px;"><b>Year</b></td><td style="padding:8px 12px;">%2</td></tr>' +
           '</table>' +
           '<p>This report summarizes your salary details for the entire year. If you have any questions or need further clarification, please contact our HR team at <a href="mailto:' + HRMail + '" style="color:#2d6ca2;text-decoration:underline;">' + HRMail + '</a>.</p>' +
           '<p style="margin-top:24px;">Best regards,<br><b>HR Department</b></p>' +
           '</div>',
           EmployeeRec.FullName(),
           Format(SalaryYear));

        Clear(EmailMessage);
        EmailMessage.Create(EmployeeRec."E-Mail", EmailSubject, EmailBody, true);

        if not Email.Send(EmailMessage) then
            Error('Failed to send email.');
    end;
}
