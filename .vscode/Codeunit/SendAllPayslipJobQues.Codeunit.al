codeunit 60003 "Send All Payslip JobQueue"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        PayslipSender: Codeunit "Send All Payslips";
    begin
        PayslipSender.SendAllPayslips();
    end;


    procedure RegisterLastDayMonthlyJobQueueEntry()
    var
        JobQueueEntry: Record "Job Queue Entry";
        LastDay: Date;
    begin
        // Check if job queue entry already exists
        JobQueueEntry.Reset();
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", 60003);
        if not JobQueueEntry.IsEmpty then begin
            Message('Monthly payslip job queue entry already exists.');
            exit;
        end;

        Clear(JobQueueEntry);
        JobQueueEntry.Init();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := 60003;
        JobQueueEntry.Description := 'Send Monthly Salary Slip';
        JobQueueEntry.Status := JobQueueEntry.Status::Ready;
        JobQueueEntry."Recurring Job" := true;

        // Calculate next last day of month
        LastDay := CalcDate('<CM>', Today);
        if LastDay <= Today then
            LastDay := CalcDate('<CM+1M>', Today);

        JobQueueEntry."Earliest Start Date/Time" := CreateDateTime(LastDay, 080000T); // 8 AM on last day
        JobQueueEntry."No. of Minutes between Runs" := 43800; // Approximately 1 month (30.4 days)
        JobQueueEntry."Maximum No. of Attempts to Run" := 3;
        JobQueueEntry."Rerun Delay (sec.)" := 300; //* 5 minutes delay on rerun
        JobQueueEntry.Insert(true);

        Message('Monthly payslip job queue entry has been registered successfully.');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Queue Start Codeunit", 'OnAfterRun', '', false, false)]
    local procedure OnAfterJobQueueRun(var JobQueueEntry: Record "Job Queue Entry")
    begin
        // Update next run time for monthly job to next month's last day
        if (JobQueueEntry."Object Type to Run" = JobQueueEntry."Object Type to Run"::Codeunit) and
           (JobQueueEntry."Object ID to Run" = 60003) then begin
            JobQueueEntry."Earliest Start Date/Time" := CreateDateTime(CalcDate('<CM+1M>', Today), 080000T);
            JobQueueEntry.Modify();
        end;
    end;
}