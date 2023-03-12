$(document).ready(function () {
    $(document).on('click', '.update_info_product', function (event) {
        event.preventDefault();
        let id = $(event.currentTarget).data('id');
        let colorID = $(event.currentTarget).data('color');
        let sizeID = $(event.currentTarget).data('size');
        let cartID = $(event.currentTarget).data('cartid')
        $.ajax({
            url: "/Cart/DataForModal/",
            type: "GET",
            data: {
                id: id,
                sizeid: sizeID,
                colorid: colorID,
                cartid: cartID
            },
            success: function (data) {
                $("#modalProduct").html(data);
                $("#modalProduct").modal('show');
                checkItem();
            },
            error: function () {
                alert("Error retrieving product details.");
            }
        });
    })
});

let VNDong = new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND',
});

function checkItem() {
    let colorCheckbox = document.querySelectorAll('.color-checkbox');
    let colorValue = document.querySelectorAll('.color-checkbox-value');
    let sizeCheckbox = document.querySelectorAll('.size-checkbox');
    let sizeValue = document.querySelectorAll('.size-checkbox-value');

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


    colorCheckbox.forEach(function (item, index) {
        item.addEventListener('click', function (event) {
            item.classList.toggle('active-custom');
            checkRadio(colorCheckbox, colorValue);
            if (item.classList.contains('active-custom')) {
                colorValue[index].checked = true;
                var i = 0;
                for (; i < colorCheckbox.length; i++) {
                    if (i == index) continue;
                    colorCheckbox[i].classList.remove('active-custom');
                }
            }
            else {
                colorValue[index].checked = false;
            }
        })
    })

    sizeCheckbox.forEach(function (item, index) {
        item.addEventListener('click', function (event) {
            item.classList.toggle('active-custom');
            checkRadio(sizeCheckbox, sizeValue);
            if (item.classList.contains('active-custom')) {
                sizeValue[index].checked = true;
                var i = 0;
                for (; i < sizeCheckbox.length; i++) {
                    if (i == index) continue;
                    sizeCheckbox[i].classList.remove('active-custom');
                }
            }
            else {
                sizeValue[index].checked = false;
            }
        })
    })
}

$(document).ready(function () {
    $(document).on('click', '.btn-input', function (event) {
        event.preventDefault();
        let id = $(event.currentTarget).data("act");
        let idInput = $(event.currentTarget).data("cartid");
        let min = $("#" + idInput).attr("min");
        let max = $("#" + idInput).attr("max");
        let step = 1;
        let val = $("#" + idInput).attr("value");
        let calcStep = (id == "increase") ? (step * 1) : (step * -1)
        let newValue = parseInt(val) + calcStep;
        if (newValue >= min && newValue <= max) {
            $("#" + idInput).attr("value", newValue);
        }
        if (idInput !== 272) {
            $.ajax({
                url: "/Cart/JustUpdateQuantity",
                type: "POST",
                data: {
                    quantity: newValue,
                    cartid: idInput,
                },
                success: function (data) {
                    $('#cart-container').load('/Cart/Index #cart-container');
                    toastr.success(data)
                },
                error: function () {
                    toastr.error("Cannot update product!");
                }
            });
        }
    })
});

$(document).ready(function () {
    $(document).on('click', '#submitformfrommodal', function (event) {
        let productId = $('input[name=productId]').val();
        let colorName = $('.color-checkbox.active-custom').text();
        let proColor = $('.color-checkbox.active-custom').siblings('.' + colorName).val();
        let sizeName = $('.size-checkbox.active-custom').text();
        let proSize = $('.size-checkbox.active-custom').siblings('.' + sizeName).val();
        let quantity = $('input[name=quantity]').val();
        let cartID = $(event.currentTarget).data('cartid');
        let proPrice = parseInt($('#product-price').text());
        //console.log("productID: " + productId);
        //console.log("size: " + proSize);
        //console.log("color: " + proColor);
        //console.log("quantity: " + quantity);
        //console.log("cartid: " + cartID);
        //console.log("price: " + proPrice)
        //console.log(typeof (proPrice));

        event.preventDefault();
        $.ajax({
            url: "/Cart/UpdateInfProduct",
            type: "POST",
            data: {
                productid: productId,
                proSize: proSize,
                proColor: proColor,
                quantity: quantity,
                cartid: cartID,
                proPrice: proPrice,
            },
            success: function (data) {
                $('#cart-container').load('/Cart/Index #cart-container');
                toastr.success(data)
            },
            error: function () {
                toastr.error("Cannot update product!");
            }
        });
        $('#modalProduct').modal('hide');
    })
});