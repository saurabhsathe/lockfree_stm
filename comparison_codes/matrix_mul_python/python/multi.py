def multiply(mat1,mat2):
    mat1=[[10,20,30],[100,200,300],[1000,2000,3000]]
    mat2=[[40,50,60],[400,500,600],[4000,5000,6000]]
    ans=[[0,0,0],[0,0,0],[0,0,0]]
    for i in range(0,len(mat1)):
        for j in range(0,len(mat2[0])):
            for k in range(0,len(mat)):
                ans[i][j]=mat1[i][k]*mat2[k][j]
    #print(ans)
    


