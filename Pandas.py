import numpy as np
import pandas as pd

# Write a Pandas program to get the powers of an array values element-wise.
# Note: First array elements raised to powers from second array


# What is "powers of an array value element-wise"?
    # powers = exponent
    # array = x, y, z
    # element = individual values

Sample_data = {'X':[78,85,96,80,86], 
               'Y':[84,94,89,83,86],
               'Z':[86,97,96,72,83]}
df = pd.DataFrame(Sample_data)

# first attempt
Answer = np.power(df.X, df.Y)

# Second attempt: disecting 
df['Answer'] = 0
for i in range(len(df.X)):
    print(df.X[i], df.Y[i])
    df.Answer[i] = np.power(df.X[i], df.Y[i])
df.Answer
