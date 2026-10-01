enum 60000 "Payroll Component Type"
{
    Extensible = true;

    value(0; Earning)
    {
        Caption = 'Earning';
    }
    value(1; Deduction)
    {
        Caption = 'Deduction';
    }
    value(2; "Employer Contribution")
    {
        Caption = 'Employer Contribution';
    }
}