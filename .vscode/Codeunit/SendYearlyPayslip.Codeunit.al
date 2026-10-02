// codeunit 50124 "SendYPayslips"
// {
//     procedure SendYearlyPayslipToEmployee()
//     var
//         YearlyPayslipCU: Codeunit "YearlyPayslipEmail Management";
//         SalaryDetailsRec: Record SalaryDetails;
//     begin
//         YearlyPayslipCU.SendYearlyPayslipToEmployee(SalaryDetailsRec);
//     end;
// }