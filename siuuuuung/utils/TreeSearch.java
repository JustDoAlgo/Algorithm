package utils;

import java.util.*;


// 인접 배열의 루트 노드 인덱스를 0으로 하였음

public class TreeSearch {
    // ★ Java 실행의 진입점 - 반드시 String[] args 형태여야 함
    public static void main(String[] args) {
        int[] nodes = {1, 2, 3, 4, 5, 6, 7};
        
        
        String preorderResult = preorder(nodes, 0).trim();
        String inorderResult = inorder(nodes, 0).trim();
        String postorderResult = postorder(nodes, 0).trim();

        System.out.println("Preorder: " + preorderResult);
        System.out.println("Inorder: " + inorderResult);
        System.out.println("Postorder: " + postorderResult);
    }

    // 전위순회: 부모 -> 좌식 -> 우식
    // 중위순회: 좌식 -> 부모 -> 우식
    // 후위순회: 좌식 -> 우식 -> 부모 
    private static String preorder(int[] nodes, int idx){
        if(idx>=nodes.length) return "";

        return nodes[idx] + " " + preorder(nodes, 2*idx+1) 
        + preorder(nodes, 2*idx+2);
    }

    private static String inorder(int[] nodes, int idx){
        if(idx>=nodes.length) return "";

        return inorder(nodes, 2*idx+1) + nodes[idx]+ " "
        + inorder(nodes, 2*idx+2);
    }

    private static String postorder(int[] nodes, int idx){
        if(idx>=nodes.length) return "";

        return postorder(nodes, 2*idx+1) + postorder(nodes, 2*idx+2)
        + nodes[idx]+ " ";
    }

}
