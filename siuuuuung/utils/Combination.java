package utils;

import java.util.*;

public class Combination {

    private static ArrayList<String> list = new ArrayList<>();

    public static void main(String[] args){
        Scanner sc = new Scanner(System.in);
        String x = sc.nextLine();

        combinations(0, x.toCharArray(), "");
        System.out.println(list);
    }

    public static void combinations(int idx, char[] order, String result){
        if(result.length()>0){
            list.add(result);
        }

        for(int i= idx; i< order.length; i++){
            combinations(i+1, order, result+order[i]);
        }
    }
}