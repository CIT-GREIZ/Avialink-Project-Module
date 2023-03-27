pageextension 50501 "Purchase Invoice Job Ext." extends "Purchase Invoice"
{



    layout
    {
    }

    actions
    {
        addafter("Co&mments")
        {
            action("Projekte")
            {
                ApplicationArea = All;
                Visible = true;
                Promoted = true;
                //PromotedCategory = "navigation";
                PromotedCategory = Category5;
                Caption = 'Zugehörige Projekte';

                trigger OnAction()
                var
                    TranslationTable: Record "Job Purchase Invoice Relation";
                begin
                    TranslationTable.SetRange(PruchaseInvoiceID, Rec."No.");
                    Page.Run(Page::"Inv.-Job Relaction", TranslationTable);
                end;
            }
        }
    }
}