page 50500 "Job-Inv. Relaction"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "Job Purchase Invoice Relation";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Item)
            {


                field(JobID; Rec.JobID)
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    //DrillDownPageId = "Job Card";
                    Editable = false;
                    TableRelation = Job."No.";
                    Caption = 'Projekt Nr.';

                    trigger OnDrillDown()
                    var
                        Jobs: Record Job;
                    begin
                        Jobs.SetRange("No.", Rec.JobID);
                        Page.Run(Page::"Job Card", Jobs);
                    end;
                }
                field(PruchaseInvoiceID; Rec.PruchaseInvoiceID)
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    //DrillDownPageId = "Purchase Invoice";
                    TableRelation = "Purchase Header"."No.";
                    Caption = 'Einkaufsrechnungs Nr.';

                    trigger OnDrillDown()
                    var
                        Invoices: Record "Purchase Header";
                    begin
                        Invoices.SetRange("No.", Rec.PruchaseInvoiceID);
                        Page.Run(Page::"Purchase Invoice", Invoices);
                    end;
                }
                field("Keditor Nr."; Invoice."Creditor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fäligkeitsdatum"; Invoice."Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Kontakt"; Invoice."Pay-to Contact")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Ked.-Rechnungsnr."; Invoice."Vendor Invoice No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Buchungsdatum"; Invoice."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Status"; Invoice.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                //field("Mwst.-Datum"; Invoice."VAT Reporting Date")
                //{

                //}
                field(Commentar; Invoice.Comment)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Invoice.Reset();
        Invoice.SetRange("No.", Rec.PruchaseInvoiceID);
        Invoice.FindFirst();
    end;

    var
        Invoice: Record "Purchase Header";
}