# step 1:language selected - python
# step 2:converting graph to adjacency matrix 
import numpy as np
print("enter number of vertices in the graph")
n=int(input())
print("enter\n 1-if the vertices are connected \n 0 -if the vertices are not connected\n")
am = [[0 for x in range(n)] for y in range(n)] 
for i in range(0,n):
    for j in range(i,n):
        if i==j:
            am[i][j]=0
        else:
           print("Is vertex ",(i+1)," connected with",(j+1))
           am[i][j]=int(input())
           am[j][i]=am[i][j]
print("******")
print("The adjacency matrix of the graph is :")
for i in range(0,n):
    for j in range(0,n):  
        print(am[i][j],end=" ")
    print("")
    
print("******")
triangles = []
am1=np.matrix(am)
am2=am1**2
am3=am2*am-np.diag(np.diag(am2))
print("******")
# step 3: check for triangles  
triangles = []
def find_triangle(i):
    vertex_triangle=[]
    for j in range(0,n):
        if am3[i, j] != 0:
            for k in range(0,n):
                if i!=j and j!=k :
                   if am1[i,j]==1 and am1[j,k]==1 and am1[k,i]==1:
                      vertex_triangle.append([i+1,j+1,k+1])
                if am1[i, k] != 0 and am1[k, j] != 0:
                    if i<j and j<k:
                        triangles.append([i+1, j+1, k+1])
    return vertex_triangle

#step 4: printing triangles for each vertex
for i in range(0,n):
    vm=find_triangle(i)
    print("Triangles for vertex ",i+1)
    for j in vm:
        print(j)
    print("******")
    
# Step 5: Printing the overall triangles in the graph
print("******") 
print("Available Triangles:", triangles)
print("******") 
#count of triangles
count=0
for i in triangles:
    count=count+1
print("The number of triangles in the inputed graph are :",count)
print("******")
