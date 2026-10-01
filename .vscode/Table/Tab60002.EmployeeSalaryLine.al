table 60002 "Employee Salary Line"
{
    Caption = 'Employee Salary Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
            NotBlank = true;
        }
        field(2; "Component Code"; Code[20])
        {
            Caption = 'Component Code';
            TableRelation = "Salary Component" where(Blocked = const(false));
            NotBlank = true;

            trigger OnValidate()
            var
                SalaryComponent: Record "Salary Component";
            begin
                if "Component Code" = '' then
                    exit;
                SalaryComponent.Get("Component Code");
                Description := SalaryComponent.Description;
                "Component Type" := SalaryComponent."Component Type";
                "Calculation Type" := SalaryComponent."Calculation Type";
                Percentage := SalaryComponent.Percentage;
                if "Component Code" <> xRec."Component Code" then
                    Amount := 0;
            end;
        }
        field(3; "Effective From"; Date)
        {
            Caption = 'Effective From';
            NotBlank = true;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(5; "Component Type"; Enum "Payroll Component Type")
        {
            Caption = 'Component Type';
            Editable = false;
        }
        field(6; "Calculation Type"; Enum "Payroll Calc Type")
        {
            Caption = 'Calculation Type';

            trigger OnValidate()
            begin
                if "Calculation Type" = "Calculation Type"::"Fixed Amount" then
                    Percentage := 0
                else
                    Amount := 0;
            end;
        }
        field(7; Percentage; Decimal)
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
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
            MinValue = 0;

            trigger OnValidate()
            begin
                if (Amount <> 0) and ("Calculation Type" <> "Calculation Type"::"Fixed Amount") then
                    Error(AmountNotAllowedErr, FieldCaption(Amount), FieldCaption("Calculation Type"), "Calculation Type");
            end;
        }
    }

    keys
    {
        key(PK; "Employee No.", "Component Code", "Effective From")
        {
            Clustered = true;
        }
    }

    var
        PercentNotAllowedErr: Label '%1 cannot be specified when %2 is %3.', Comment = '%1 = Percentage caption, %2 = Calculation Type caption, %3 = Calculation Type value';
        AmountNotAllowedErr: Label '%1 cannot be specified when %2 is %3.', Comment = '%1 = Amount caption, %2 = Calculation Type caption, %3 = Calculation Type value';
}
