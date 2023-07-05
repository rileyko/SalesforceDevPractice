/**
 * @description       :
 * @author            : Woolim Ko
 * @group             : Trestle
 * @last modified on  : 07-03-2023
 * @last modified by  : Woolim Ko
 **/
import { LightningElement, api, wire } from "lwc";
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import STAGE_NAME_FIELD from "@salesforce/schema/Opportunity.StageName";

const DELAY = 350;

export default class OpptyFilter extends LightningElement {
    searchKeyword;
    selectedStage = "All";
    Amount = 1000000;
    picklistValues;

    @api
    searchKeywords(str) {
        if (str !== null || str !== "") {
            this.searchKeyword = str;
        }
    }

    @wire(getPicklistValues, { recordTypeId: "0126e000001Z10s", fieldApiName: STAGE_NAME_FIELD })
    //StageNamePicklistValues;
    getPicklistValues({ data, error }) {
        if (data) {
            console.log(this.picklistValues);
            this.picklistValues = [{ value: " ", label: "All" }, ...data.values];
        } else if (error) {
            console.log("error: " + JSON.stringify(error));
        }
    }

    handleSearchKeyChange(event) {
        this.searchKeyword = event.detail.value;
        this.dispatchEvent(new CustomEvent("keyword", { detail: this.searchKeyword }));
    }
    handleStageNameChange(event) {
        this.selectedStage = event.detail.value;
        this.dispatchEvent(new CustomEvent("stagename", { detail: this.selectedStage }));
    }
}
