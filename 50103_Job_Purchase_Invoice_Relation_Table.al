table 50503 "Job Purchase Invoice Relation"
{
    DataClassification = ToBeClassified;


    fields
    {
        field(1; JobID; Code[20])
        {
            DataClassification = ToBeClassified;

            TableRelation = Job."No.";
        }
        field(2; PruchaseInvoiceID; Code[20])
        {
            DataClassification = ToBeClassified;

            TableRelation = "Purchase Header"."No.";
        }
    }

    keys
    {
        key(PK; JobID, PruchaseInvoiceID)
        {
            Clustered = true;
        }

    }

    trigger OnInsert()
    var
        Job: Record Job;
    begin
        Job.SetRange("No.", Rec.JobID);
        Job.ModifyAll("Purchase Invoice Exists", true, true);
    end;

    trigger OnDelete()
    var
        TranslationTable: Record "Job Purchase Invoice Relation";
        Job: Record Job;
    begin
        TranslationTable.SetRange(JobID, Rec.JobID);
        if TranslationTable.Count() = 1 then begin
            Job.SetRange("No.", Rec.JobID);
            if Job.FindFirst() then begin
                Job."Purchase Invoice Exists" := false;
                Job.Modify();
                Commit();
            end;
        end;
    end;

    trigger OnModify()
    var
        Job: Record Job;
        TranslationTable: Record "Job Purchase Invoice Relation";
    begin
        Job.SetRange("No.", Rec.JobID);
        Job.ModifyAll("Purchase Invoice Exists", true, true);

        TranslationTable.SetRange(JobID, xRec.JobID);
        if not TranslationTable.FindFirst() then begin
            Job.SetRange("No.", Rec.JobID);
            if Job.FindFirst() then begin
                Job."Purchase Invoice Exists" := false;
                Job.Modify();
                Commit();
            end;
        end;
    end;
}