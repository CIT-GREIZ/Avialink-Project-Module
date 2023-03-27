pageextension 50502 "Job Card Purchase Invoice Ext." extends "Job Card"
{
    layout
    {
        /*addafter("% Invoiced")
        {
            field("Purchase Invoice Exists"; BoolToText(Rec."Purchase Invoice Exists"))
            {
                DrillDown = true;
                ApplicationArea = All;
                Caption = 'Einkaufsrechnung';

                trigger OnDrillDown()
                var
                    TranslationTable: Record "Job Purchase Invoice Relation";
                begin
                    if Rec."Purchase Invoice Exists" = true then begin
                        TranslationTable.SetRange(JobID, Rec."No.");
                        Page.Run(Page::"Job-Inv. Relaction", TranslationTable);
                    end else begin
                        CreateAndRunNewPurchaseInvoice();
                    end;
                end;
            }
        }*/
    }

    actions
    {
        addafter("Job - Planning Lines")
        {

            action(ShowPurchaseInvoices)
            {
                ApplicationArea = All;
                Caption = 'Einkaufsrechnungen Anzeigen';
                Promoted = true;
                PromotedCategory = Category6;

                trigger OnAction()
                var
                    TranslationTable: Record "Job Purchase Invoice Relation";
                begin
                    TranslationTable.SetRange(JobID, Rec."No.");
                    Page.Run(Page::"Job-Inv. Relaction", TranslationTable);
                end;
            }

            action(SalesInvoicesCreditMemosMoved)
            {
                ApplicationArea = Jobs;
                Caption = 'Sales &Invoices/Credit Memos';
                Image = GetSourceDoc;
                ToolTip = 'View sales invoices or sales credit memos that are related to the selected job.';
                Promoted = true;
                PromotedCategory = Category6;

                trigger OnAction()
                var
                    JobInvoices: Page "Job Invoices";
                begin
                    JobInvoices.SetPrJob(Rec);
                    JobInvoices.RunModal();
                end;
            }
        }
        addafter("Copy Job Tasks &to...")
        {
            action("Create Job &Sales Invoice")
            {
                ApplicationArea = Jobs;
                Caption = 'Projectverkaufsrechnung erstellen';
                Image = JobSalesInvoice;
                //RunObject = Report "Job Create Sales Invoice";
                ToolTip = 'Use a batch job to help you create job sales invoices for the involved job planning lines.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    JobTask: Record "Job Task";
                begin
                    JobTask.SetRange("Job No.", Rec."No.");
                    Report.Run(Report::"Job Create Sales Invoice", true, true, JobTask);
                end;
            }

            action(NewPurchaseInvoice)
            {
                ApplicationArea = All;
                Caption = 'Neue Einkaufsrechnung';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CreateAndRunNewPurchaseInvoice();
                end;
            }
        }
    }

    local procedure CreateAndRunNewPurchaseInvoice()
    var
        PurchaseInvoice: Record "Purchase Header";
        TranslationTable: Record "Job Purchase Invoice Relation";
    begin
        PurchaseInvoice.Init();
        PurchaseInvoice.Validate("Document Type", PurchaseInvoice."Document Type"::Invoice);
        PurchaseInvoice.Insert(true);

        Commit();

        TranslationTable.Init();
        TranslationTable.JobID := Rec."No.";
        TranslationTable.PruchaseInvoiceID := PurchaseInvoice."No.";
        TranslationTable.Insert(true);
        Commit();
        Page.Run(Page::"Purchase Invoice", PurchaseInvoice);
    end;

    local procedure BoolToText(Bool: Boolean) Text: Text
    begin
        if Bool then begin
            Text := 'Ja';
        end else begin
            Text := 'Nein'
        end;
    end;

    /*
        trigger OnAfterGetRecord()
        var
            Setup: Record "Jobs Setup";
        begin
            if Setup.FindFirst() then begin
                Rec."WIP Method" := Setup."Default WIP Method";
                Rec."Job Posting Group" := Setup."Default Job Posting Group";
            end;
        end;
    */
}