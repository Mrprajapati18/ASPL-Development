page 60002 "Employee Salary Subform"
{
    Caption = 'Salary Structure';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Employee Salary Line";
    AutoSplitKey = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Component Code"; Rec."Component Code")
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
                field("Effective From"; Rec."Effective From")
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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}