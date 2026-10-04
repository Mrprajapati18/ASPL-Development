permissionset 60000 "HR PAYROLL"
{
    Caption = 'HR Payroll';
    Assignable = true;
    Permissions = tabledata "Salary Component" = RIMD,
        tabledata "Employee Salary Line" = RIMD,
        tabledata Employee = R,
        table "Salary Component" = X,
        table "Employee Salary Line" = X,
        table Employee = X,
        page "Salary Components" = X,
        page "Employee Salary Subform" = X,
        report "Salary Slip" = X,
        codeunit "Payslip Email Management" = X,
        codeunit "Send All Payslip JobQueue" = X,
        codeunit "Send All Payslips" = X,
        codeunit "YearlyPayslipEmail Management" = X;
}