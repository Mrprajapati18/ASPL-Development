pageextension 60000 "HR Payroll Employee Card" extends "Employee Card"
{
    layout
    {
        addafter("No.")
        {
            field("EMP ID"; Rec."EMP ID")
            {
                ApplicationArea = All;

            }

        }
        addafter(Personal)
        {
            group("Salary Structure Details")
            {
                Caption = 'Salary Details';
                part(SalaryStructure; "Employee Salary Subform")
                {
                    ApplicationArea = All;
                    SubPageLink = "Employee No." = field("No.");
                }
            }

        }
        addafter("Working Hours")
        {

            field("Payroll Applicable"; Rec."Payroll Applicable")
            {
                ApplicationArea = All;
            }
            field("Basic Salary"; Rec."Basic Salary")
            {
                ApplicationArea = All;
            }
            field("PF Applicable"; Rec."PF Applicable")
            {
                ApplicationArea = All;
            }
            field("ESI Applicable"; Rec."ESI Applicable")
            {
                ApplicationArea = All;
            }
            field("PAN No."; Rec."PAN No.")
            {
                ApplicationArea = All;
            }
            field("UAN No."; Rec."UAN No.")
            {
                ApplicationArea = All;
            }
            field(PayDays; Rec.PayDays)
            {
                ApplicationArea = All;
            }

            field("PF Account No."; Rec."PF Account No.")
            {
                ApplicationArea = All;
            }
            field("ESI No."; Rec."ESI No.")
            {
                ApplicationArea = All;
            }
            group("Leave Balances")
            {
                Caption = 'Leave Balances';

                field("Earn Leave Opening Balance"; Rec."Earn Leave Opening Balance")
                {
                    ApplicationArea = All;
                }
                field("Earn Leave Availed"; Rec."Earn Leave Availed")
                {
                    ApplicationArea = All;
                }
                field("Sick Leave Opening Balance"; Rec."Sick Leave Opening Balance")
                {
                    ApplicationArea = All;
                }
                field("Sick Leave Availed"; Rec."Sick Leave Availed")
                {
                    ApplicationArea = All;
                }
                field("Casual Leave Opening Balance"; Rec."Casual Leave Opening Balance")
                {
                    ApplicationArea = All;
                }
                field("Casual Leave Availed"; Rec."Casual Leave Availed")
                {
                    ApplicationArea = All;
                }
                field("Rest Day Opening Balance"; Rec."Rest Day Opening Balance")
                {
                    ApplicationArea = All;
                }
                field("Rest Day Availed"; Rec."Rest Day Availed")
                {
                    ApplicationArea = All;
                }
                field("Comp Offs Opening Balance"; Rec."Comp Offs Opening Balance")
                {
                    ApplicationArea = All;
                }
                field("Comp Offs Availed"; Rec."Comp Offs Availed")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        addbefore(Email)
        {
            action(PrintSalarySlip)
            {
                ApplicationArea = All;
                Caption = 'Print Salary Slip';
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                Image = Print;

                trigger OnAction()
                var
                    EmployeeRec: Record Employee;
                begin
                    EmployeeRec.Get(Rec."No.");
                    Report.RunModal(Report::"Salary Slip", true, false, EmployeeRec);
                end;
            }
        }
    }
}