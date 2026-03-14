/*
26.03.14 18:40~18:55
6603 로또
백트래킹 마스터 한듯??
*/

#include <iostream>
using namespace std;

int k; 
int arr[55];
int result[55];
bool visited[55];

void func(int n)
{
    if (n == 6)
    {
        for (int i=0; i<6; ++i)
            cout << result[i] << ' ';
        cout << '\n';
        return;
    }

    for (int i=n; i<k; ++i)
    {
        if (visited[i]) continue;
        if (i > 0 && result[n-1] >= arr[i]) continue;

        visited[i] = true;
        result[n] = arr[i];
        func(n+1);
        visited[i] = false;
    }
}

int main()
{
    cin.tie(0);
    cout.tie(0);
    ios::sync_with_stdio(0);

    while (true)
    {
        cin >> k;
        if (k == 0) break;

        for (int i=0; i<k; ++i)
        {
            cin >> arr[i];
            visited[i] = false;
        }
        
        func(0);

        cout << '\n';
    }
}