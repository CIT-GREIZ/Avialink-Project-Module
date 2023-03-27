tableextension 50500 "Job Purchase Invoice Ext." extends Job
{
    fields
    {
        field(50000; "Purchase Invoice Exists"; Boolean)
        {

        }
    }

    trigger OnBeforeInsert()
    var
        JobSetup: Record "Jobs Setup";
    begin
        Rec."Purchase Invoice Exists" := false;
        if JobSetup.FindFirst() then begin
            Rec."WIP Method" := JobSetup."Default WIP Method";
            Rec."Job Posting Group" := JobSetup."Default Job Posting Group";
            Rec.Status := JobSetup.DefaultJobStatus;
        end;
    end;
}