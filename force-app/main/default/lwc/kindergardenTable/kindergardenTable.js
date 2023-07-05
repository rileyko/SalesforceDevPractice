/**
 * @description       :
 * @author            : Woolim Ko
 * @group             : Trestle
 * @last modified on  : 07-04-2023
 * @last modified by  : Woolim Ko
 **/
import { LightningElement } from "lwc";
import makeCallout from "@salesforce/apex/KindergardenInfoCallout.makeCallout";
import { ssgCodeOptions } from "./ssgData";

const columns = [
    {
        label: "kindername",
        fieldName: "kindername",
        type: "text"
    },
    {
        label: "ldgrname",
        fieldName: "ldgrname",
        type: "text"
    },
    {
        label: "establish",
        fieldName: "establish",
        type: "text"
    },
    {
        label: "addr",
        fieldName: "addr",
        type: "text"
    }
];

export default class KindergardenTable extends LightningElement {
    get options() {
        return [
            { label: "서울특별시", value: "11" },
            { label: "부산광역시", value: "26" },
            { label: "대구광역시", value: "27" },
            { label: "인천광역시", value: "28" },
            { label: "광주광역시", value: "29" },
            { label: "대전광역시", value: "30" },
            { label: "울산광역시", value: "31" },
            { label: "세종특별자치시", value: "36" },
            { label: "경기도", value: "41" },
            { label: "충청북도", value: "43" },
            { label: "충청남도", value: "44" },
            { label: "전라북도", value: "45" },
            { label: "전라남도", value: "46" },
            { label: "경상북도", value: "47" },
            { label: "경상남도", value: "48" },
            { label: "제주특별자치도", value: "50" },
            { label: "강원특별자치도", value: "51" }
        ];
    }

    columns = columns;
    sidoCode = "11";
    sggCode = "11140";
    calloutResult;
    displayResult;
    clickedButtonLabel = "Show Only Ten";
    ssgCodeOptionsData = [];
    sggData;
    ssgDataSize;

    //life Cycle
    connectedCallback() {
        this.makeCallout();
        this.sggData = ssgCodeOptions;
        this.getSggCodeList(this.sidoCode);
    }
    renderedCallback() {
        this.ssgDataSize = this.ssgCodeOptionsData;
    }

    //Rest
    makeCallout() {
        makeCallout({
            sidoCode: this.sidoCode,
            sggCode: this.sggCode
        }).then((result) => {
            this.calloutResult = result.kinderInfo;
            this.displayResult = this.calloutResult;
        });
    }

    //Handle
    handleChangeSido(event) {
        this.sidoCode = event.detail.value;
        this.makeCallout(this.sidoCode);
        this.getSggCodeList(this.sidoCode);
    }
    handleChangeSgg(event) {
        this.sggCode = event.detail.value;
        this.makeCallout(this.sggCode);
    }
    handleClick(event) {
        const label = event.target.label;
        if (label === "Show More") {
            this.clickedButtonLabel = "Show Only Ten";
            this.displayResult = this.calloutResult;
        } else if (label === "Show Only Ten") {
            this.clickedButtonLabel = "Show More";
            this.displayResult = this.calloutResult.slice(0, 10);
        }
    }
    getSggCodeList(sidoParam) {
        this.ssgCodeOptionsData = [];
        this.sggData.forEach((item) => {
            if (item.sidoCode === sidoParam) {
                this.ssgCodeOptionsData.push({ label: item.Name, value: item.sggCode });
            }
        });
    }
}
