/**
 * @description       :
 * @author            : Woolim Ko
 * @group             : Trestle
 * @last modified on  : 06-28-2023
 * @last modified by  : Woolim Ko
 **/
import { LightningElement, api, wire } from "lwc";
import getOpptyLists from "@salesforce/apex/OpptyController.getOpptyLists";
import getNext from "@salesforce/apex/OpptyController.getNext";
import getPrevious from "@salesforce/apex/OpptyController.getPrevious";
import getTotalOpty from "@salesforce/apex/OpptyController.getTotalOpty";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import updateOppties from "@salesforce/apex/OpptyController.updateOppties";
import { notifyRecordUpdateAvailable } from "lightning/uiRecordApi";

const columns = [
    {
        label: "Name",
        fieldName: "Name",
        sortable: true,
        type: "text",
        editable: true
    },
    {
        label: "Stage",
        fieldName: "StageName",
        type: "picklist",
        sortable: true,
        typeAttributes: {
            placeholder: "Choose Stage",
            options: [
                { label: "Needs Analysis", value: "Needs Analysis" },
                { label: "Id. Decision Makers", value: "Id. Decision Makers" },
                { label: "Perception Analysis", value: "Perception Analysis" },
                { label: "Prospecting", value: "Prospecting" },
                { label: "Value Proposition", value: "Value Proposition" }
            ],
            value: { fieldName: "StageName" },
            context: { fieldName: "Id" },
            variant: "label-hidden",
            name: "Stage",
            label: "Stage"
        },
        cellAttributes: {
            class: { fieldName: "stageClass" }
        }
    },
    {
        label: "Created Date",
        fieldName: "CreatedDate",
        type: "date",
        sortable: true
    },
    {
        label: "Closed Date",
        fieldName: "CloseDate",
        type: "date-local",
        sortable: true,
        typeAttributes: {
            day: "numeric",
            month: "numeric",
            year: "numeric"
        },
        editable: true
    },
    {
        label: "Amount",
        fieldName: "Amount",
        type: "currency",
        sortable: true,
        editable: true
    }
];

export default class OpptyTable extends LightningElement {
    // Search 용
    searchKeyword;
    selectedStage;
    // 보여주기 용
    opptyList;
    columns = columns;
    // Sort 용
    sortBy;
    sortDirection;
    // Pagination 용
    offsetVal = 0;
    pageSize = 10;
    totalOppty;
    pageNumber = 1;
    totalPageNum;
    // Spinner
    imgSrc =
        "https://trestle66-dev-ed.develop.file.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0686e00000ZsiQh&operationContext=CHATTER&contentId=05T6e00001lLoX5";
    isLoaded = false;
    // Edit
    draftValues = [];

    connectedCallback() {
        this.getOpptyLists();
    }

    isRendered = false;
    renderedCallback() {
        if (this.isRendered) return;
        this.isRendered = true;

        console.log(this.pageNumber);
        console.log(this.totalPageNum);
    }

    // Get Oppty List
    getOpptyLists() {
        this.isLoaded = true;
        getOpptyLists({
            searchKeyword: this.searchKeyword,
            stageName: this.selectedStage,
            offsetVal: this.offsetVal,
            pageSize: this.pageSize
        })
            .then((result) => {
                this.opptyList = result;
            })
            .catch((error) => {
                console.log("error " + error.message);
            })
            .finally(() => {
                setTimeout(() => {
                    this.isLoaded = false;
                }, "500");
            });
        this.getTotalOpty();
    }

    getTotalOpty() {
        getTotalOpty({
            searchKeyword: this.searchKeyword,
            stageName: this.selectedStage
        }).then((result) => {
            this.totalOppty = result;
        });
    }
    // Sorting
    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.opptyList));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === "asc" ? 1 : -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : "";
            y = keyValue(y) ? keyValue(y) : "";
            return isReverse * ((x > y) - (y > x));
        });
        this.opptyList = parseData;
    }

    // Paginator
    previousHandler2() {
        console.log("previous");
        getPrevious({ offsetVal: this.offsetVal, pageSize: this.pageSize }).then((result) => {
            this.offsetVal = result;
            if (this.offsetVal === 0) {
                this.template.querySelector("c-paginator").changeView("trueprevious");
            } else {
                this.template.querySelector("c-paginator").changeView("falsenext");
            }
            this.getOpptyLists();
            this.pageNumber -= 1;
        });
    }
    nextHandler2() {
        console.log("next");
        getNext({ offsetVal: this.offsetVal, pageSize: this.pageSize }).then((result) => {
            this.offsetVal = result;
            if (this.offsetVal + 10 > this.totalOppty) {
                this.template.querySelector("c-paginator").changeView("truenext");
            } else {
                this.template.querySelector("c-paginator").changeView("falseprevious");
            }
            this.getOpptyLists();
            this.pageNumber += 1;
        });
    }
    changeHandler2(event) {
        const det = event.detail;
        this.pageSize = det;
        this.getOpptyLists();
    }
    firstpagehandler2() {
        console.log("first");
        this.offsetVal = 0;
        this.template.querySelector("c-paginator").changeView("trueprevious");
        this.template.querySelector("c-paginator").changeView("falsenext");
        this.getOpptyLists();
        this.pageNumber = 1;
    }
    lastpagehandler2() {
        console.log("last");
        this.offsetVal = this.totalOppty - (this.totalOppty % this.pageSize);
        this.template.querySelector("c-paginator").changeView("falseprevious");
        this.template.querySelector("c-paginator").changeView("truenext");
        this.getOpptyLists();
        this.pageNumber = Math.ceil(this.totalOppty / this.pageSize);
    }
    // Do search
    handleSearchKeyChange(event) {
        this.searchKeyword = event.detail;
        this.getOpptyLists();
    }
    handleStageNameChange(event) {
        this.selectedStage = event.detail;
        this.getOpptyLists();
    }

    async saveHandleAction(event) {
        const updatedFields = event.detail.draftValues;
        console.log(updatedFields);
        console.log(event.detail.row);
        const notifyChangeIds = updatedFields.map((row) => {
            return { recordId: row.Id };
        });

        try {
            const result = await updateOppties({ data: updatedFields });
            console.log(JSON.stringify("Apex update result: " + result));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Success",
                    message: "Oppty updated",
                    variant: "success"
                })
            );
            notifyRecordUpdateAvailable(notifyChangeIds);
            await refreshApex(this.opptyList);
            this.draftValues = [];
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error updating or refreshing records",
                    message: error.body.message,
                    variant: "error"
                })
            );
        }
    }
}
