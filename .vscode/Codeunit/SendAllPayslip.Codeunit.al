codeunit 60001 "Send All Payslips"
{
    procedure SendAllPayslips()
    var
        Employee: Record Employee;
        PayslipReport: Codeunit "Payslip Email Management";
    begin
        Employee.Reset();
        if Employee.FindSet() then
            repeat
                if (Employee."Company E-Mail" <> '') or (Employee."E-Mail" <> '') then
                    PayslipReport.SendEmailToEmployee(Employee);
            until Employee.Next() = 0;
    end;
}