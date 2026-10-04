codeunit 60001 "Send All Payslips"
{
    procedure SendAllPayslips()
    var
        Employee: Record Employee;
        PayslipReport: Codeunit "Payslip Email Management";
        SalaryMonth: Date;
    begin
        SalaryMonth := CalcDate('<-1M>', Today);
        Employee.Reset();
        if Employee.FindSet() then
            repeat
                PayslipReport.SendMonthlySalarySlipReportToEmployee(Employee, SalaryMonth);
            until Employee.Next() = 0;
    end;
}