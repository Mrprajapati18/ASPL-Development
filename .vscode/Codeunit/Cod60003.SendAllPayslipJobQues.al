codeunit 60003 "Send All Payslip JobQueue"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        PayslipSender: Codeunit "Send All Payslips";
    begin
        PayslipSender.SendAllPayslips();
    end;
}