tableextension 60000 "HR Payroll Employee Ext" extends Employee
{
    fields
    {
        field(50100; "Payroll Applicable"; Boolean)
        {
            Caption = 'Payroll Applicable';
            DataClassification = CustomerContent;
        }
        field(50101; "Basic Salary"; Decimal)
        {
            Caption = 'Basic Salary';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50102; "PF Applicable"; Boolean)
        {
            Caption = 'PF Applicable';
            DataClassification = CustomerContent;
        }
        field(50103; "ESI Applicable"; Boolean)
        {
            Caption = 'ESI Applicable';
            DataClassification = CustomerContent;
        }
        field(50104; "PAN No."; Code[10])
        {
            Caption = 'PAN No.';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            begin
                if "PAN No." <> '' then
                    if StrLen("PAN No.") <> 10 then
                        Error(InvalidLengthErr, FieldCaption("PAN No."), 10);
            end;
        }
        field(50105; "UAN No."; Code[12])
        {
            Caption = 'UAN No.';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            begin
                if "UAN No." <> '' then
                    if StrLen("UAN No.") <> 12 then
                        Error(InvalidLengthErr, FieldCaption("UAN No."), 12);
            end;
        }
        field(50106; "PF Account No."; Code[30])
        {
            Caption = 'PF Account No.';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50107; "ESI No."; Code[17])
        {
            Caption = 'ESI No.';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            begin
                if "ESI No." <> '' then
                    if StrLen("ESI No.") <> 17 then
                        Error(InvalidLengthErr, FieldCaption("ESI No."), 17);
            end;
        }
        field(50108; "Earn Leave Opening Balance"; Decimal)
        {
            Caption = 'Earn Leave Opening Balance';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50109; "Earn Leave Availed"; Decimal)
        {
            Caption = 'Earn Leave Availed';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50110; "Sick Leave Opening Balance"; Decimal)
        {
            Caption = 'Sick Leave Opening Balance';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50111; "Sick Leave Availed"; Decimal)
        {
            Caption = 'Sick Leave Availed';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50112; "Casual Leave Opening Balance"; Decimal)
        {
            Caption = 'Casual Leave Opening Balance';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50113; "Casual Leave Availed"; Decimal)
        {
            Caption = 'Casual Leave Availed';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50114; "Rest Day Opening Balance"; Decimal)
        {
            Caption = 'Rest Day Opening Balance';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50115; "Rest Day Availed"; Decimal)
        {
            Caption = 'Rest Day Availed';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50116; "Comp Offs Opening Balance"; Decimal)
        {
            Caption = 'Comp Offs Opening Balance';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50117; "Comp Offs Availed"; Decimal)
        {
            Caption = 'Comp Offs Availed';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(50118; PayDays; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50119; "EMP ID"; Code[12])
        {
            DataClassification = ToBeClassified;
        }
        field(50120; "Salary Slip Email Status"; Option)
        {
            Caption = 'Salary Slip Email Status';
            OptionMembers = Pending,Sent,Error;
            OptionCaption = 'Pending,Sent,Error';
            DataClassification = CustomerContent;
        }
        field(50121; "Salary Slip Status Date"; DateTime)
        {
            Caption = 'Salary Slip Status Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50122; "Salary Slip Status Message"; Text[250])
        {
            Caption = 'Salary Slip Status Message';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    var
        InvalidLengthErr: Label '%1 must be exactly %2 characters long.', Comment = '%1 = Field caption, %2 = Required length';
}