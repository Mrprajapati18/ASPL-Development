table 60001 "Salary Component"
{
    Caption = 'Salary Component';
    DataClassification = CustomerContent;
    LookupPageId = "Salary Components";
    DrillDownPageId = "Salary Components";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Component Type"; Enum "Payroll Component Type")
        {
            Caption = 'Component Type';
        }
        field(4; "Calculation Type"; Enum "Payroll Calc Type")
        {
            Caption = 'Calculation Type';

            trigger OnValidate()
            begin
                if "Calculation Type" = "Calculation Type"::"Fixed Amount" then
                    Percentage := 0;
            end;
        }
        field(5; Percentage; Decimal)
        {
            Caption = 'Percentage';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                if (Percentage <> 0) and ("Calculation Type" = "Calculation Type"::"Fixed Amount") then
                    Error(PercentNotAllowedErr, FieldCaption(Percentage), FieldCaption("Calculation Type"), "Calculation Type");
            end;
        }
        field(6; Taxable; Boolean)
        {
            Caption = 'Taxable';
            InitValue = true;
        }
        field(7; "Include in PF Wage"; Boolean)
        {
            Caption = 'Include in PF Wage';
        }
        field(8; "Include in ESI Wage"; Boolean)
        {
            Caption = 'Include in ESI Wage';
        }
        field(9; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account" where("Account Type" = const(Posting), "Direct Posting" = const(true));
        }
        field(10; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description, "Component Type") { }
    }

    trigger OnDelete()
    var
        EmployeeSalaryLine: Record "Employee Salary Line";
    begin
        EmployeeSalaryLine.SetRange("Component Code", Code);
        if not EmployeeSalaryLine.IsEmpty() then
            Error(ComponentInUseErr, TableCaption, Code);
    end;

    var
        PercentNotAllowedErr: Label '%1 cannot be specified when %2 is %3.', Comment = '%1 = Percentage caption, %2 = Calculation Type caption, %3 = Calculation Type value';
        ComponentInUseErr: Label '%1 %2 is used in employee salary structures and cannot be deleted.', Comment = '%1 = Table caption, %2 = Code';
}
