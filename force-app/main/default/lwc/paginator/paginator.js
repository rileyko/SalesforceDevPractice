/**
 * @description       :
 * @author            : Woolim Ko
 * @group             : Trestle
 * @last modified on  : 06-20-2023
 * @last modified by  : Woolim Ko
 **/
import { LightningElement, api } from 'lwc';

export default class Paginator extends LightningElement {
  @api pageNumber;
  @api totalPageNum;
  @api totalOppty;
  @api pageSize;

  @api
  changeView(str) {
    if (str === 'trueprevious') {
      this.template.querySelector('lightning-button.Previous').disabled = true;
    }
    if (str === 'falseprevious') {
      this.template.querySelector('lightning-button.Previous').disabled = false;
    }
    if (str === 'truenext') {
      this.template.querySelector('lightning-button.Next').disabled = true;
    }
    if (str === 'falsenext') {
      this.template.querySelector('lightning-button.Next').disabled = false;
    }
  }
  renderedCallback() {
    if (this.offsetVal === 0) {
      this.template.querySelector('lightning-button.Previous').disabled = true;
    }
  }
  previousHandler1() {
    this.dispatchEvent(new CustomEvent('previous'));
  }

  nextHandler1() {
    this.dispatchEvent(new CustomEvent('next'));
  }
  FirstPageHandler1() {
    this.dispatchEvent(new CustomEvent('firstpage'));
  }
  LastPageHandler1() {
    this.dispatchEvent(new CustomEvent('lastpage'));
  }
  changeHandler(event) {
    event.preventDefault();
    const clickPageButton = event.target.value;
    const selectedEvent = new CustomEvent('selected', { detail: clickPageButton });
    this.dispatchEvent(selectedEvent);
  }

  get totalPages() {
    return Math.ceil(this.totalOppty / this.pageSize);
  }
}