pageextension 50502 "Job Card Purchase Invoice Ext." extends "Job Card"
{
    layout
    {
        addafter("% Invoiced")
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
        }
    }

    actions
    {
        addafter(Attachments)
        {

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

            action(ShowPurchaseInvoices)
            {
                ApplicationArea = All;
                Caption = 'Einkaufsrechnungen Anzeigen';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TranslationTable: Record "Job Purchase Invoice Relation";
                begin
                    TranslationTable.SetRange(JobID, Rec."No.");
                    Page.Run(Page::"Job-Inv. Relaction", TranslationTable);
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