pageextension 50500 "Job List Purchase Invoice Ext." extends "Job List"
{


    layout
    {
        addafter("% Invoiced")
        {
            field(PurchaseInvoiceExists; BoolToText(Rec."Purchase Invoice Exists"))
            {
                ApplicationArea = All;

                DrillDown = true;

                Caption = 'Einkaufsrechnung';

                trigger OnDrillDown()
                var
                    PurchaseInvoicePage: Page "Purchase Invoice";
                    PurchaseInvoice: Record "Purchase Header";

                    TranslationTable: Record "Job Purchase Invoice Relation";
                begin
                    if Rec."Purchase Invoice Exists" = true then begin
                        TranslationTable.SetRange(JobId, Rec."No.");
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
        addafter(CopyJob)
        {
            action("Create Job Purchase Invoice")
            {
                ApplicationArea = All;
                Caption = 'Einkaufsrechnung Erstellen';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Job: Record Job;
                begin
                    //if Rec.FindFirst() then begin
                    CreateAndRunNewPurchaseInvoice();
                    //end else begin
                    //    Message(NoProjectSeletetError)
                    //end;
                end;
            }

            action(ShowPurchaseInvoices)
            {
                ApplicationArea = All;
                Caption = 'Einkaufsrechnungen anzeigen';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TranslationTable: Record "Job Purchase Invoice Relation";
                begin
                    //if Rec.FindFirst() then begin
                    TranslationTable.SetRange(JobID, Rec."No.");
                    Page.Run(Page::"Job-Inv. Relaction", TranslationTable);
                    //end else begin
                    //    Message(NoProjectSeletetError);
                    //end;
                end;
            }
        }
    }

    local procedure CreateAndRunNewPurchaseInvoice()
    var
        PurchaseInvoice: Record "Purchase Header";
        TranslationTable: Record "Job Purchase Invoice Relation";
    //TestPage: Page "Purchase Invoice";
    begin
        PurchaseInvoice.Init();
        PurchaseInvoice.Validate("Document Type", PurchaseInvoice."Document Type"::Invoice);
        PurchaseInvoice.Insert(true);

        Commit();

        TranslationTable.Init();
        TranslationTable.JobID := Rec."No.";
        TranslationTable.PruchaseInvoiceID := PurchaseInvoice."No.";
        TranslationTable.Insert(true);

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

    var
        NoProjectSeletetError: Label 'Wählen sie ein Projekt aus';
}