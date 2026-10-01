report 60000 "Salary Slip"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Salary Slip';
    DefaultLayout = RDLC;
    RDLCLayout = 'Layout/EmployeeSalarySlipUpdated.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "EMP ID";

            column(CompName; 'Atisunya Private Limited')
            {
            }
            column(CompAddr; CompanyInformation.Address)
            {
            }
            column(CompPics; CompanyInformation.Picture)
            {
            }
            column(SlipTitle; SlipTitleText)
            {
            }
            column(EmpNo; "No.")
            {
            }
            column(EmpName; EmployeeName)
            {
            }
            column(JobTitle; "Job Title")
            {
            }
            column(GenderText; Format(Gender))
            {
            }
            column(LocationText; City)
            {
            }
            column(JoinDate; JoinDateText)
            {
            }
            column(PANNo; "PAN No.")
            {
            }
            column(UANNo; "UAN No.")
            {
            }
            column(ESINo; "ESI No.")
            {
            }
            column(BankAccNo; "Bank Account No.")
            {
            }
            column(PayDays; PayDays)
            {
            }
            column(EMP_ID; "EMP ID")
            {
            }
            column(AttendanceArrearDays; AttendanceArrearDays)
            {
            }
            column(IncrementArrearDays; IncrementArrearDays)
            {
            }
            column(BasicSalary; BasicSalary)
            {
            }
            column(NetSalary; NetSalary)
            {
            }
            column(NetPayInWords; NetPayInWords)
            {
            }
            column(BasicSalaryInWords; BasicSalaryInWords)
            {
            }
            column(EarnLeaveOpening; "Earn Leave Opening Balance")
            {
            }
            column(EarnLeaveAvailed; "Earn Leave Availed")
            {
            }
            column(SickLeaveOpening; "Sick Leave Opening Balance")
            {
            }
            column(SickLeaveAvailed; "Sick Leave Availed")
            {
            }
            column(CasualLeaveOpening; "Casual Leave Opening Balance")
            {
            }
            column(CasualLeaveAvailed; "Casual Leave Availed")
            {
            }
            column(RestDayOpening; "Rest Day Opening Balance")
            {
            }
            column(RestDayAvailed; "Rest Day Availed")
            {
            }
            column(CompOffsOpening; "Comp Offs Opening Balance")
            {
            }
            column(CompOffsAvailed; "Comp Offs Availed")
            {
            }

            dataitem(SalaryLine; "Employee Salary Line")
            {
                DataItemLink = "Employee No." = field("No.");
                DataItemTableView = sorting("Employee No.", "Component Code", "Effective From");

                column(ComponentRate; ComponentRate)
                {
                }
                column(MonthlyAmount; MonthlyAmount)
                {
                }
                column(ArrearAmount; ArrearAmount)
                {
                }
                column(ComponentTotal; ComponentTotal)
                {
                }
                column(EarnDesc; EarningDescription)
                {
                }
                column(EarnAmt; EarningAmount)
                {
                }
                column(DedAmt; DeductionAmount)
                {
                }
                trigger OnPreDataItem()
                begin
                    SetRange("Effective From", 0D, SalaryMonthEnd);
                end;

                trigger OnAfterGetRecord()
                begin
                    if not IsLatestSalaryLine(SalaryLine) then
                        CurrReport.Skip();

                    ComponentAmount := CalculateComponentAmount(SalaryLine, Employee, TotalEarnings);
                    ComponentRate := GetComponentRate(SalaryLine);
                    MonthlyAmount := ComponentAmount;
                    ArrearAmount := 0;
                    ComponentTotal := MonthlyAmount + ArrearAmount;

                    EarningDescription := '';
                    EarningAmount := 0;
                    DeductionAmount := 0;
                    case "Component Type" of
                        "Component Type"::Earning:
                            begin
                                EarningDescription := Description;
                                EarningAmount := ComponentAmount;
                                if Description <> 'Basic' then
                                    TotalEarnings += ComponentAmount;
                            end;
                        "Component Type"::Deduction:
                            DeductionAmount := ComponentAmount;
                        "Component Type"::"Employer Contribution":
                            CurrReport.Skip();
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                EmployeeName := GetEmployeeName(Employee);
                JoinDateText := Format(Employee."Employment Date");
                BasicSalary := Employee."Basic Salary";
                TotalEarnings := 0;
                NetSalary := Round(CalculateNetSalary(Employee), 0.01, '=');
                NetPayInWords := AmountToWords(NetSalary);
                BasicSalaryInWords := AmountToWords(BasicSalary);
                // PayDays := Date2DMY(SalaryMonthEnd, 1);
                AttendanceArrearDays := 0;
                IncrementArrearDays := 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(SalaryMonth; SalaryMonth)
                    {
                        ApplicationArea = All;
                        Caption = 'Salary Month';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if SalaryMonth = 0D then
            Error(SalaryMonthRequiredErr);

        CompanyInformation.Get();
        CompanyInformation.CalcFields(Picture);
        SalaryMonthEnd := CalcDate('<CM>', SalaryMonth);
        SalaryMonthText := Format(SalaryMonth, 0, '<Month Text> <Year4>');
        SlipTitleText := StrSubstNo('Salary Slip - %1', SalaryMonthText);
    end;

    var
        CompanyInformation: Record "Company Information";
        SalaryMonth: Date;
        SalaryMonthEnd: Date;
        SalaryMonthText: Text[50];
        SlipTitleText: Text[100];
        PayDays: Decimal;
        AttendanceArrearDays: Decimal;
        IncrementArrearDays: Decimal;
        EmployeeName: Text[100];
        JoinDateText: Text[30];
        ComponentAmount: Decimal;
        ComponentRate: Decimal;
        MonthlyAmount: Decimal;
        ArrearAmount: Decimal;
        ComponentTotal: Decimal;
        EarningDescription: Text[100];
        EarningAmount: Decimal;
        DeductionAmount: Decimal;
        BasicSalary: Decimal;
        TotalEarnings: Decimal;
        NetSalary: Decimal;
        NetPayInWords: Text[250];
        BasicSalaryInWords: Text[250];
        SalaryMonthRequiredErr: Label 'Salary Month must be specified.';

    local procedure IsLatestSalaryLine(EmployeeSalaryLine: Record "Employee Salary Line"): Boolean
    var
        LatestSalaryLine: Record "Employee Salary Line";
    begin
        LatestSalaryLine.SetRange("Employee No.", Employee."No.");
        LatestSalaryLine.SetRange("Component Code", EmployeeSalaryLine."Component Code");
        LatestSalaryLine.SetRange("Effective From", 0D, SalaryMonthEnd);
        if not LatestSalaryLine.FindLast() then
            exit(false);

        exit(LatestSalaryLine."Effective From" = EmployeeSalaryLine."Effective From");
    end;

    local procedure GetEmployeeName(EmployeeRec: Record Employee): Text[100]
    var
        EmployeeNameText: Text[100];
    begin
        EmployeeNameText := EmployeeRec."First Name";
        if EmployeeRec."Middle Name" <> '' then begin
            if EmployeeNameText <> '' then
                EmployeeNameText += ' ';
            EmployeeNameText += EmployeeRec."Middle Name";
        end;
        if EmployeeRec."Last Name" <> '' then begin
            if EmployeeNameText <> '' then
                EmployeeNameText += ' ';
            EmployeeNameText += EmployeeRec."Last Name";
        end;

        exit(EmployeeNameText);
    end;

    local procedure CalculateNetSalary(EmployeeRec: Record Employee): Decimal
    var
        SalaryLineRec: Record "Employee Salary Line";
        CalculatedEarnings: Decimal;
        CalculatedDeductions: Decimal;
        LineAmount: Decimal;
    begin
        SalaryLineRec.SetCurrentKey("Employee No.", "Component Code", "Effective From");
        SalaryLineRec.SetRange("Employee No.", EmployeeRec."No.");
        SalaryLineRec.SetRange("Effective From", 0D, SalaryMonthEnd);
        if SalaryLineRec.FindSet() then
            repeat
                if IsLatestSalaryLine(SalaryLineRec) then begin
                    LineAmount := CalculateComponentAmount(SalaryLineRec, EmployeeRec, CalculatedEarnings);
                    case SalaryLineRec."Component Type" of
                        SalaryLineRec."Component Type"::Earning:
                            if SalaryLineRec.Description <> 'Basic' then
                                CalculatedEarnings += LineAmount;
                        SalaryLineRec."Component Type"::Deduction:
                            CalculatedDeductions += LineAmount;
                    end;
                end;
            until SalaryLineRec.Next() = 0;

        exit(EmployeeRec."Basic Salary" + CalculatedEarnings - CalculatedDeductions);
    end;

    local procedure CalculateComponentAmount(EmployeeSalaryLine: Record "Employee Salary Line"; EmployeeRec: Record Employee; CurrentTotalEarnings: Decimal): Decimal
    var
        SalaryComponent: Record "Salary Component";
    begin
        if EmployeeSalaryLine."Component Code" = '' then
            exit(0);

        if not SalaryComponent.Get(EmployeeSalaryLine."Component Code") then
            exit(0);

        case EmployeeSalaryLine."Calculation Type" of
            EmployeeSalaryLine."Calculation Type"::"Fixed Amount":
                exit(EmployeeSalaryLine.Amount);
            EmployeeSalaryLine."Calculation Type"::"Percent of Basic":
                begin
                    if EmployeeSalaryLine.Percentage = 0 then
                        exit(0);
                    exit((EmployeeSalaryLine.Percentage / 100) * EmployeeRec."Basic Salary");
                end;
            EmployeeSalaryLine."Calculation Type"::"Percent of Gross":
                begin
                    if EmployeeSalaryLine.Percentage = 0 then
                        exit(0);
                    exit((EmployeeSalaryLine.Percentage / 100) * (EmployeeRec."Basic Salary" + CurrentTotalEarnings));
                end;
            else
                exit(0);
        end;
    end;

    local procedure GetComponentRate(EmployeeSalaryLine: Record "Employee Salary Line"): Decimal
    begin
        case EmployeeSalaryLine."Calculation Type" of
            EmployeeSalaryLine."Calculation Type"::"Fixed Amount":
                exit(EmployeeSalaryLine.Amount);
            EmployeeSalaryLine."Calculation Type"::"Percent of Basic",
            EmployeeSalaryLine."Calculation Type"::"Percent of Gross":
                exit(EmployeeSalaryLine.Percentage);
            else
                exit(0);
        end;
    end;

    local procedure AmountToWords(Amount: Decimal): Text[250]
    var
        WholeAmount: BigInteger;
        Paise: Integer;
        Words: Text[250];
        IsNegative: Boolean;
    begin
        IsNegative := Amount < 0;
        Amount := Round(Abs(Amount), 0.01, '=');
        WholeAmount := Amount div 1;
        Paise := Round((Amount - WholeAmount) * 100, 1, '=');
        Words := NumberToWords(WholeAmount);
        if IsNegative then
            Words := StrSubstNo('Minus %1', Words);
        if Paise > 0 then
            Words := StrSubstNo('%1 and %2 Paise', Words, NumberToWords(Paise));
        exit(StrSubstNo('%1 Only', Words));
    end;

    local procedure NumberToWords(Number: BigInteger): Text[250]
    var
        Words: Text[250];
        Part: BigInteger;
    begin
        if Number = 0 then
            exit('Zero');

        Part := Number div 10000000;
        if Part > 0 then begin
            AppendWords(Words, StrSubstNo('%1 Crore', NumberToWords(Part)));
            Number := Number mod 10000000;
        end;
        Part := Number div 100000;
        if Part > 0 then begin
            AppendWords(Words, StrSubstNo('%1 Lakh', NumberToWords(Part)));
            Number := Number mod 100000;
        end;
        Part := Number div 1000;
        if Part > 0 then begin
            AppendWords(Words, StrSubstNo('%1 Thousand', NumberToWords(Part)));
            Number := Number mod 1000;
        end;
        Part := Number div 100;
        if Part > 0 then begin
            AppendWords(Words, StrSubstNo('%1 Hundred', NumberToWords(Part)));
            Number := Number mod 100;
        end;
        if Number > 0 then
            AppendWords(Words, TwoDigitNumberToWords(Number));
        exit(Words);
    end;

    local procedure TwoDigitNumberToWords(Number: BigInteger): Text[30]
    var
        TensText: Text[15];
    begin
        case Number of
            1:
                exit('One');
            2:
                exit('Two');
            3:
                exit('Three');
            4:
                exit('Four');
            5:
                exit('Five');
            6:
                exit('Six');
            7:
                exit('Seven');
            8:
                exit('Eight');
            9:
                exit('Nine');
            10:
                exit('Ten');
            11:
                exit('Eleven');
            12:
                exit('Twelve');
            13:
                exit('Thirteen');
            14:
                exit('Fourteen');
            15:
                exit('Fifteen');
            16:
                exit('Sixteen');
            17:
                exit('Seventeen');
            18:
                exit('Eighteen');
            19:
                exit('Nineteen');
        end;

        case Number div 10 of
            2:
                TensText := 'Twenty';
            3:
                TensText := 'Thirty';
            4:
                TensText := 'Forty';
            5:
                TensText := 'Fifty';
            6:
                TensText := 'Sixty';
            7:
                TensText := 'Seventy';
            8:
                TensText := 'Eighty';
            9:
                TensText := 'Ninety';
        end;
        if Number mod 10 > 0 then
            exit(StrSubstNo('%1 %2', TensText, TwoDigitNumberToWords(Number mod 10)));
        exit(TensText);
    end;

    local procedure AppendWords(var Words: Text[250]; AdditionalWords: Text[250])
    begin
        if Words <> '' then
            Words += ' ';
        Words += AdditionalWords;
    end;
}
