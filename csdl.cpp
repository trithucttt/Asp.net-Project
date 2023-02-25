#include<iostream>
using namespace std;

void insertImage(int idStart, int idPdStart, int quantity)
{
    int i = 0, j = 1;
    for (i = idPdStart; i < quantity; i++)
    {
        j = 1;
        for(; j < 5; j++)
        {
            cout << "insert into Image values (" << idStart << ",'../../Content/images/products/pd"<< i <<"."<< j << ".jpg')" << endl;
            idStart++;
        }
    }
}

void insertProductImage(int idPdStart, int quantity, int IdImageStart)
{
    int i = 0, j = 1;
    for (i = idPdStart; i <= quantity; i++)
    {
        j = 1;
        // moi sp co 4 tam anh
        for(; j < 5; j++)
        {
            cout << "insert into Product_Image values (" << i << ", " << IdImageStart << ")" << endl;
            IdImageStart++;
        }
    }
}

void insertQuantity(int idPdStart, int quantity, int color1, int color2)
{
    // 2 mau black 1 white 2 pink 3 blue 4 purple 5 tuy vay 1 sp lay 2 mau
    // 4 size 1 2 3 4
    //(product_id, size_id, color_id, quantity)
    int i = 0, j = 0, k = 1;
    int c1 = color1;
    int c2 = color2;
    int rad;
    for (i = idPdStart; i <= quantity; i++)
    {
        j = 1;
        for(; j < 2; j++) // color
        {
            
        }
    }
}

int main() {
    //insertImage(1, 1, 11);
    //insertProductImage(1, 10, 1);
    insertQuantity(1, 1, 1, 2);
    return 0;
}
