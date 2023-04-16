# Step 1: Language selected - Python
# Step 2: Converting graph to adjacency matrix 
print("Enter the number of vertices in the graph")
n = int(input())
print("Enter 1 if the vertices are connected, and 0 if the vertices are not connected")
adjacency_matrix = [[0 for x in range(n)] for y in range(n)] 
for i in range(n):
    for j in range(i,n):
        if i == j:
            adjacency_matrix[i][j] = 0
        else:
           print("Is vertex ", (i+1), " connected with ", (j+1))
           adjacency_matrix[i][j] = int(input())
           adjacency_matrix[j][i] = adjacency_matrix[i][j]

# Step 3: Triangle counting using matrix multiplication
import numpy as np
A = np.matrix(adjacency_matrix)
A2 = A**2
A3 = A2*A - np.diag(np.diag(A2))

# Step 4: Extracting the triangles from the matrix product
triangles = []
for i in range(n):
    for j in range(n):
        if A3[i, j] != 0:
            for k in range(n):
                if A[i, k] != 0 and A[k, j] != 0:
                    if i < j and j < k:
                        triangles.append([i+1, j+1, k+1])

# Step 5: Printing the overall triangles in the graph
print("The adjacency matrix of the graph is:")
for i in range(n):
    for j in range(n):  
        print(adjacency_matrix[i][j], end=" ")
    print("")
print("Available Triangles:", triangles)
