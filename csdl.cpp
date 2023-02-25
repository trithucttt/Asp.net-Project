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

void insertQuantity(int idPdStart, int quantity, int color1, int color2, int radomIndex)
{
    // 2 mau black 1 white 2 pink 3 blue 4 purple 5 ,tuy vay 1 sp lay 2 mau
    // 4 size 1 2 3 4
    //(product_id, size_id, color_id, quantity)
    int i = 0, j = 1, k = 0;
    int c1 = color1;
    int c2 = color2;
    int rad1, rad2;
    for (i = idPdStart; i <= quantity; i++)
    {
        j = 1;
        for (; j < 5; j++) {
            k = 0;
            for (; k < 2; k++)
            {
                rad1 = 100 + (rand() % radomIndex);
                //rad1 = 100 + (rand() % 1034);
                if (k % 2 == 0)
                    cout << "insert into Product_Quantity values ("<< i <<", "<< j <<", "<< color1 <<", "<< rad1 <<")" << endl;
                else
                    cout << "insert into Product_Quantity values ("<< i <<", "<< j <<", "<< color2 <<", "<< rad1 <<")" << endl;

            }
        }
    }
}


void insertProductTag(int idTag, int arrProductSameTag[], int quantity)
{
    int i = 0, j = 1;
    for (i = 0; i < quantity; i++)
    {
        cout << "insert into Product_Tag values ("<< arrProductSameTag[i] <<", "<< idTag <<")" << endl;
    }
}

void insertProductCategory(int arrProduct[], int quantity)
{
    int i = 0, j;
    for (i = 0; i < quantity; i++)
    {
        j = 0;
        for (j = 0; j < 2; j++) {
            if (j % 2 == 0)
                cout << "insert into Product_Category values("<< arrProduct[i] <<", "<< 4 <<")" << endl;
            else
                cout << "insert into Product_Category values("<< arrProduct[i] <<", "<< 5 <<")" << endl;
        }
        
    }
}

int main() {
    //insertImage(1, 1, 11);
    //insertProductImage(1, 10, 1);
    //insertQuantity(10, 10, 1, 3, 116);
    int a[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    //insertProductTag(8, a, 4);
    insertProductCategory(a, 10);
    return 0;
}
