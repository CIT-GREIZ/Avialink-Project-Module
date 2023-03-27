pageextension 50504 "Job Planing Line Ext." extends "Job Planning Lines"
{
    layout
    {

    }

    actions
    {
        addafter("Create &Sales Invoice")
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
                    TranslationTable.SetRange(JobID, Rec."Job No.");
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
        TranslationTable.JobID := Rec."Job No.";
        TranslationTable.PruchaseInvoiceID := PurchaseInvoice."No.";
        TranslationTable.Insert(true);

        Page.Run(Page::"Purchase Invoice", PurchaseInvoice);
    end;
}