/**
 * @description       :
 * @author            : Woolim Ko
 * @group             : Trestle
 * @last modified on  : 06-28-2023
 * @last modified by  : Woolim Ko
 **/
import LightningDatatable from "lightning/datatable";
import DatatablePicklistTemplate from "./picklistTemplate.html";

export default class CustomDatatable extends LightningDatatable {
    static customTypes = {
        picklist: {
            template: DatatablePicklistTemplate,
            standardCellLayout: true,
            typeAttributes: ["label", "placeholder", "options", "value", "context", "variant", "name"]
        }
    };
}
