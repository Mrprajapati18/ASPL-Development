page 60001 "Salary Components"
{
    Caption = 'Salary Components';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Salary Component";
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Component Type"; Rec."Component Type")
                {
                    ApplicationArea = All;
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                    ApplicationArea = All;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                }
                field(Taxable; Rec.Taxable)
                {
                    ApplicationArea = All;
                }
                field("Include in PF Wage"; Rec."Include in PF Wage")
                {
                    ApplicationArea = All;
                }
                field("Include in ESI Wage"; Rec."Include in ESI Wage")
                {
                    ApplicationArea = All;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}