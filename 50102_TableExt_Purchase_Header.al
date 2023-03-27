tableextension 50502 "Purchase Header Deletion Task" extends "Purchase Header"
{

    trigger OnBeforeDelete()
    var
        TranslationTable: Record "Job Purchase Invoice Relation";
    begin
        TranslationTable.SetRange(PruchaseInvoiceID, Rec."No.");
        TranslationTable.DeleteAll(true);
    end;

}