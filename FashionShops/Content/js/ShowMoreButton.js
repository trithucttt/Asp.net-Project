

// Show more theo số chỉ định


////$(document).ready(function () {
////    var showMoreBtn = $('#show-more-btn');
////    var categoriesList = $('.sidebar_categories');

////    showMoreBtn.on('click', function () {
////        categoriesList.toggleClass('show-more');

////        // Hiển thị hoặc ẩn các mục trong danh sách dựa trên lớp 'show-more'
////        if (categoriesList.hasClass('show-more')) {
////            categoriesList.find('li:hidden').slice(0, 20).show();
////        } else {
////            categoriesList.find('li').slice(5).hide();
////        }

////        // Thay đổi nội dung của nút 'Show more/less' tương ứng
////        if (categoriesList.hasClass('show-more')) {
////            showMoreBtn.html('Show less');
////        } else {
////            showMoreBtn.html('Show more');
////        }
////    });

////});



// Button show more theo danh sách ko biết trước
$(document).ready(function () {
    var showMoreBtn = $('#show-more-btn');
    var categoriesList = $('.sidebar_categories');
    var numToShow = 5;
    var numInList = categoriesList.find('li').length;

    // Ẩn các phần tử trừ các phần tử chọn trước
    categoriesList.find('li').slice(numToShow).hide();

    showMoreBtn.on('click', function () {
        // chuyển đổi lớp show-more'
        categoriesList.toggleClass('show-more');

        // Hiển thị hoặc ẩn các mục trong danh sách dựa trên lớp 'show-more'
        categoriesList.find('li').slice(numToShow).toggle(categoriesList.hasClass('show-more'));

        // Thay đổi nội dung của nút 'Show more/less' tương ứng
        if (categoriesList.find('li:hidden').length === 0) {
            showMoreBtn.html('+ Show less');
        } else {
            showMoreBtn.html('+ Show more');
        }
    });
});




$(document).ready(function () {
    var showMoreBtn = $('#show-more-color');
    var colorList = $('.sidebar_color');
    var numToShow = 5;
    var numInList = colorList.find('li').length;

    // Ẩn các phần tử trừ các phần tử chọn trước
    /*colorList.find('li').slice(numToShow).hide();*/
    showMoreBtn.on('click', function () {
        colorList.toggleClass('show-more');

        // Hiển thị hoặc ẩn các mục trong danh sách dựa trên lớp 'show-more'
        if (colorList.hasClass('show-more')) {
            colorList.find('li:hidden').slice(0, 20).show();
        } else {
            colorList.find('li').slice(5).hide();
        }

        // Thay đổi nội dung của nút 'Show more/less' tương ứng
        if (colorList.hasClass('show-more')) {
            showMoreBtn.html('Show less');
        } else {
            showMoreBtn.html('Show more');
        }
    });
});
