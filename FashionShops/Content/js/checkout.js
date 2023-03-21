function PaymentDetails() {
    let totalAmountGoods = parseFloat($('#total-cost').data('totalprice'));
    let totalShippingFee = parseFloat($('input[name="shippingUnit"]:checked').val()) * 1000;
    let reduceShippingCost = 0;
    let temp1 = $('input[name="voucherFreeShip"]:checked').val();
    if (typeof temp1 !== 'undefined') {
        let temp = temp1.split('&');
        let discountFreeShipPercent = parseFloat(temp[0]);
        let maxDiscountFreeShip = parseFloat(temp[1]) * 1000;
        reduceShippingCost = totalShippingFee * discountFreeShipPercent;
        if (reduceShippingCost > maxDiscountFreeShip) reduceShippingCost = maxDiscountFreeShip;
    }
    if (isNaN(reduceShippingCost)) reduceShippingCost = 0;
    let totalDiscountVoucher = parseFloat($('input[name="shopsVoucher"]:checked').val()) * totalAmountGoods;
    if (isNaN(totalDiscountVoucher)) totalDiscountVoucher = 0;
    let totalPayment = totalAmountGoods + totalShippingFee - reduceShippingCost - totalDiscountVoucher;
    $('#amount-cost').data('price', totalAmountGoods);
    $('#amount-cost').html('Total amount of goods: ' + totalAmountGoods + '&#8363;');
    $('#total-shipping-fee').data('price', totalShippingFee);
    $('#total-shipping-fee').html('Total shipping fee: ' + totalShippingFee + '&#8363;');
    $('#reduce-shipping-cost').data('price', reduceShippingCost);
    $('#reduce-shipping-cost').html('Reduced shipping cost: ' + reduceShippingCost + '&#8363;');
    $('#total-discount-voucher').data('price', totalDiscountVoucher);
    $('#total-discount-voucher').html('Total discount voucher: ' + totalDiscountVoucher + '&#8363;');
    $('#total-payment').data('price', totalPayment);
    $('#total-payment').html('Total payment: ' + totalPayment + '&#8363;');
}
PaymentDetails();

let shopsVoucherCheck = document.querySelectorAll('.shopsVoucher-check');
let boxVoucher = document.querySelectorAll('.box_voucher');
let shopsVoucherChosen = document.querySelector('#shopsVoucherChosen');
let shopsVoucher;

shopsVoucherCheck.forEach((item, index) => {
    item.addEventListener('click', event => {
        if (boxVoucher[index].classList.contains('border-danger')) {
            item.checked = false;
            boxVoucher[index].classList.remove('border-danger');
            $('#shopsVoucherChosen').text('Choose voucher');
            setTotalCost(0);
            PaymentDetails();
        } else {
            boxVoucher[index].classList.add('border-danger');
            PaymentDetails();
            for (let i = 0; i < boxVoucher.length; i++) {
                if (i == index) continue;
                boxVoucher[i].classList.remove('border-danger');
            }
            let totalDiscount = parseFloat($('#total-cost').data('totalprice'));
            //console.log(totalDiscount);
            let discountPercent = $('input[name="shopsVoucher"]:checked').val();
            totalDiscount *= discountPercent;
            let presentVoucherChosen = totalDiscount / 1000;
            $('#shopsVoucherChosen').text('-' + presentVoucherChosen + 'K');
            setTotalCost(totalDiscount);
        }
    })
});

function setTotalCost(totalDiscount) {
    let newTotalCost = parseFloat($('#total-cost').data('totalprice')) - totalDiscount;
    $('#total-cost').text(newTotalCost);
}

function setDeliveryDate() {
    const d = new Date();
    const monthNames = ["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ];
    let currentDate = monthNames[d.getMonth()] + ' ' + d.getDate();
    let EstimatedDeliveryDate = monthNames[d.getMonth()] + ' ' + (d.getDate() + 3);
    $('#time-receive-goods').text('Receive goods on ' + currentDate + ' -> ' + EstimatedDeliveryDate);
    $('.modal-time-receive-goods').each(function () {
        $(this).text('Receive goods on ' + currentDate + ' -> ' + EstimatedDeliveryDate);
    })
}

setDeliveryDate();
let shinppingUnitCheck = document.querySelectorAll('.shipping-unit-check');
let boxShipping = document.querySelectorAll('.box-shipping-unit');
let shippingUnitChosen = document.querySelector('#shopping-unit-first-choose');
let nameShoppingUnit = document.querySelectorAll('.modal-name-shopping-unit');
let timeRecive = document.querySelectorAll('.modal-time-receive-goods');

shinppingUnitCheck.forEach((item, index) => {
    item.addEventListener('click', event => {
        if (!boxShipping[index].classList.contains('border-danger')) {
            let shipFee = $('input[name="shippingUnit"]:checked').val();
            $('#transport-fee-new').text(shipFee + 'K');
            $('#name-shopping-unit').text(nameShoppingUnit[index].textContent);
            $('#time-receive-goods').text(timeRecive[index].textContent);
            if (selectVoucherFreeShip()) {
                freeShipDiscount();
            }
            //freeShipDiscount();
            //paymentDetails(freeShipDiscount());
            boxShipping[index].classList.add('border-danger');
            for (let i = 0; i < boxShipping.length; i++) {
                if (i == index) continue;
                boxShipping[i].classList.remove('border-danger');
            }
            PaymentDetails();
        }
    })
});

function selectVoucherFreeShip() {
    let freeShipCheck = document.querySelectorAll('.free-ship-check');
    for (let i = 0; i < freeShipCheck.length; i++) {
        if (freeShipCheck[i].checked == true)
            return true;
    }
    return false;
}

let freeShipCheck = document.querySelectorAll('.free-ship-check');
let boxFreeShip = document.querySelectorAll('.box-free-ship');
freeShipCheck.forEach((item, index) => {
    item.addEventListener('click', event => {
        if (boxFreeShip[index].classList.contains('border-danger')) {
            item.checked = false;
            boxFreeShip[index].classList.remove('border-danger');
            $('#free-ship-voucher').attr('hidden', true);
            $('#transport-fee-old').attr('hidden', true);
            $('#transport-fee-new').text($('input[name="shippingUnit"]:checked').val() + 'K');
            PaymentDetails();
        } else {
            $('#free-ship-voucher').attr('hidden', false);
            freeShipDiscount();
            boxFreeShip[index].classList.add('border-danger');
            for (let i = 0; i < boxFreeShip.length; i++) {
                if (i == index) continue;
                boxFreeShip[i].classList.remove('border-danger');
            }
            PaymentDetails();
        }
    })
});

function freeShipDiscount() {
    let shippingUnitChosen = parseFloat($('input[name="shippingUnit"]:checked').val());
    let voucherFreeShipChosen = $('input[name="voucherFreeShip"]:checked').val();
    let arrFreeShip = voucherFreeShipChosen.split("&");
    let discountPercent = parseFloat(arrFreeShip[0]);
    let maxDiscount = parseFloat(arrFreeShip[1]);
    let totalDiscountFee = shippingUnitChosen * discountPercent;
    if (totalDiscountFee > maxDiscount) {
        totalDiscountFee = maxDiscount;
    }
    let finalDiscountFee = shippingUnitChosen - totalDiscountFee;
    $('#transport-fee-old').attr('hidden', false);
    $('#transport-fee-old').text(shippingUnitChosen + 'K');
    $('#transport-fee-new').text(finalDiscountFee + 'K');
    return totalDiscountFee;
}


let paymentCheckbox = document.querySelectorAll('.payment-checkbox');
let paymentValue = document.querySelectorAll('.payment-checkbox-value');
selectedPaymentMethod();
$('#payment-method-confirm').click(selectedPaymentMethod);
paymentCheckbox.forEach(function (item, index) {
    item.addEventListener('click', function (event) {
        item.classList.toggle('active-custom');
        checkRadio(paymentCheckbox, paymentValue);
        if (item.classList.contains('active-custom')) {
            paymentValue[index].checked = true;
            let i = 0;
            for (; i < paymentCheckbox.length; i++) {
                if (i == index) continue;
                paymentCheckbox[i].classList.remove('active-custom');
            }
        }
        else {
            paymentValue[index].checked = false;
        }
    })
})

function selectedPaymentMethod() {
    let selectedPM = $('input[name="paymentMethod"]:checked').data('name');
    $('#name-payment-method').html(selectedPM + ' <i class="fa-sharp fa-solid fa-chevron-right"></i>')
}

function checkRadio(check, checkValue) {
    let j = 0;
    let boolChecked = false;
    for (; j < check.length; j++) {
        if (check[j].classList.contains('active-custom')) {
            boolChecked = true;
        }
    }
    if (!boolChecked) {
        check[0].classList.add('active-custom');
        checkValue[0].checked = true;
    }
}