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
        console.log(val);
        let calcStep = (id == "increase") ? (step * 1) : (step * -1)
        let newValue = parseInt(val) + calcStep;
        if (newValue >= min && newValue <= max) {
            $("#" + idInput).attr("value", newValue);
        }
        console.log(newValue);
        console.log(idInput);
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
                    CheckoutItems();
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
                CheckoutItems();
                toastr.success(data)
            },
            error: function () {
                toastr.error("Cannot update product!");
            }
        });
        $('#modalProduct').modal('hide');
    })
});

function fitName(maxLength) {
    let productList = document.querySelectorAll('.product-name');

    // Loop through each product name in the list
    for (let i = 0; i < productList.length; i++) {
        const productName = productList[i].textContent;

        // Shorten the product name if it is too long
        if (productName.length > maxLength) {
            let shortenedName = productName.substring(0, maxLength) + '...';
            productList[i].textContent = shortenedName;
        }
    }
}

$(window).resize(function () {
    let windowWidth = $(window).width();
    if (windowWidth < 340) {
        fitName(28);
    } else if (windowWidth < 755) {
        fitName(40);
    } else if (windowWidth < 995) {
        fitName(60);
    } else {
        $('.product-name').each(function () {
            let originnalName = $(this).data('orname');
            $(this).text(originnalName);
        });
    }
});

$(document).ready(function () {
    // Khi nhấn vào nút delete bất kỳ trên danh sách
    $(document).on('click', '.remove-product', function (event) {
        // stop chuyen link khi nhấn vào thẻ <a>
        event.preventDefault();
        // hiển thị Sweetaler2 và xoá bằng ajax
        // hoặc uncomment showModalConfirm() để xoá theo kiểu bình thường
        showConfirm(event.currentTarget);
    })
});

function showConfirm(e) {
    let proName = $(e).data('name');
    if (proName.length > 15) {
        let shortenedName = proName.substring(0, 15) + '...';
        proName = shortenedName;
    }
    Swal.fire({
        title: 'Are you sure?',
        html: "<p>Delete <b>" + proName + "</b></p> <p>You won't be able to revert this!</p>",
        icon: 'warning',
        imageUrl: $(e).data('img'),
        imageWidth: 110,
        imageHeight: 170,
        showCancelButton: true,
        cancelButtonColor: '#3085d6',
        confirmButtonColor: '#d33',
        confirmButtonText: 'Confirm'
    }).then((result) => {
        if (result.isConfirmed) {
            ajaxDelete(e);
        }
    });
}

function ajaxDelete(e) {
    var url = $(e).data('urldelete');
    var cartid = $(e).data('idincart');
    $.ajax({
        method: "POST",
        url: url,
        data: {
            cartid: cartid
        }
    }).done(function (data) {
        $('#cart-container').load('/Cart/Index #cart-container');
        CheckoutItems();
        Swal.fire(
            'Deleted!',
            data,
            'success'
        );
    }).fail(function () { // nếu thất bại
        Swal.fire(
            'Error',
            'Something went wrong!',
            'error'
        )
    });
}

function setValueCost() {
    let sum = 0;
    let selectedProduct = $('.product-checkout:checked');
    selectedProduct.each(function (item) {
        //console.log(typeof($(this).data('price')));
        sum += $(this).data('price');
    });
    $('#totalCost').text(sum);
}

function ifAllCheck() {
    let allBtn = $('.product-checkout');
    for (let i = 0; i < allBtn.length - 1; i++) {
        if (allBtn[i].checked == false) {
            return false
        }
    }
    return true;
}
$('.product-checkout').not('#check-all').click(function () {
    let theLastCheckOutIndex = $('.product-checkout').length - 1;
    let allBtn = $('.product-checkout');
    if (allBtn[theLastCheckOutIndex].checked) {
        allBtn[theLastCheckOutIndex].checked = false;
    }
    setValueCost();
});

$('#check-all').click(function () {
    let theLastCheckOutIndex = $('.product-checkout').length - 1;
    let allBtn = $('.product-checkout');
    if (allBtn[theLastCheckOutIndex].checked) {
        for (let i = 0; i < allBtn.length - 1; i++) {
            if (allBtn[i].checked == false) {
                allBtn[i].checked = true;
            }
        }
        setValueCost();
        $('.product-checkout').not("#check-all").click(function () {
            setValueCost();
        });
    } else {
        if (ifAllCheck()) {
            for (let i = 0; i < allBtn.length - 1; i++) {
                allBtn[i].checked = false;
            }
            setValueCost();
        }
    }
})