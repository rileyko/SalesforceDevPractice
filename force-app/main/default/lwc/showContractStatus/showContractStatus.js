/**
 * @description       :
 * @author            : Woolim Ko
 * @group             : Trestle
 * @last modified on  : 06-21-2023
 * @last modified by  : Woolim Ko
 **/
// apexStaticSchema.js
import { LightningElement, wire, api } from 'lwc';
import getSingleContract from '@salesforce/apex/ContractController.getContractStage';

export default class ApexStaticSchema extends LightningElement {
  @api recordId;
  _StatusCode;
  _Dates;
  contract;
  error;

  isLoading = false;

  connectedCallback() {
    this.getSingleContract();
  }

  getSingleContract() {
    getSingleContract({ recordId: this.recordId })
      .then((result) => {
        this.isLoading = true;
        this.contract = result;
        console.log(this.contract);
        console.log('result: ' + result);
        console.log('result JSON: ' + JSON.stringify(result));
        this.setStatusIcon(this.contract.StatusCode);
        this.setShowingDates(this.contract.StatusCode);
        isLoading = false;
        /* PROBLEM: I want do more processing only when Apex returns an empty list, but result is always undefined */
        if (result === null || result === undefined) {
          // Do some other actions
        }
      })
      .catch((error) => {
        console.log('error ' + error.message);
      });
  }

  // 아이콘 변경
  setStatusIcon(value) {
    console.log(value);
    if (value == 'Draft') {
      this._StatusCode = '🖋️';
    } else if (value == 'InApproval') {
      this._StatusCode = '📑';
    } else {
      this._StatusCode = '✅';
    }
  }

  // 일자 변경
  setShowingDates(value) {
    if (value == 'Activated') {
      this._Dates = this.contract.ActivatedDate;
    } else {
      this._Dates = this.contract.LastModifiedDate;
    }
  }
}