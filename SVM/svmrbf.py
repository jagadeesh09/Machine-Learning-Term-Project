from sklearn import svm
import matplotlib.pyplot as plt
from matplotlib.colors import Normalize
import scipy.io
import numpy as np
from sklearn.svm import SVC
from sklearn.model_selection import StratifiedShuffleSplit
from sklearn.model_selection import GridSearchCV


class MidpointNormalize(Normalize):

    def __init__(self, vmin=None, vmax=None, midpoint=None, clip=False):
        self.midpoint = midpoint
        Normalize.__init__(self, vmin, vmax, clip)

    def __call__(self, value, clip=None):
        x, y = [self.vmin, self.midpoint, self.vmax], [0, 0.5, 1]
        return np.ma.masked_array(np.interp(value, x, y))


mat1 = scipy.io.loadmat('D:\PRML\Problems\Assignment_list\Pattern1.mat')
mat2 = scipy.io.loadmat('D:\PRML\Problems\Assignment_list\Pattern2.mat')
mat3 = scipy.io.loadmat('D:\PRML\Problems\Assignment_list\Pattern3.mat')


mat_1 = mat1['train_pattern_1']
mat_2 = mat2['train_pattern_2']
mat_3 = mat3['train_pattern_3']

mat = np.concatenate((mat_1,mat_2,mat_3),axis = 0)
#print (mat.shape)
X = np.reshape(mat,600)
X = np.array(X)
X = np.vstack(X)
#print (X)
#print (X.shape)
y = [None]*600
for i in range(1,201):
    y[i-1] = 1
    y[199+ i] = 2
    y[399 + i] = 3

#print(y.shape)

C_range = np.logspace(-2, 10, 13)
gamma_range = np.logspace(-9, 3, 13)
param_grid = dict(gamma=gamma_range, C=C_range)
cv = StratifiedShuffleSplit(y, n_iter=5, test_size=200,train_size = 400,random_state = 42)
grid = GridSearchCV(SVC(), param_grid=param_grid, cv=cv)
grid.fit(X, y)

print("The best parameters are %s with a score of %0.2f"
      % (grid.best_params_, grid.best_score_))

C_2d_range = [10, 100, 100]
gamma_2d_range = [1e-1, 1, 1e1]
classifiers = []
for C in C_2d_range:
    for gamma in gamma_2d_range:
        clf = SVC(C=C, gamma=gamma)
        clf.fit(X, y)
        classifiers.append((C, gamma, clf))
scores = [x[1] for x in grid.grid_scores_]
scores = np.array(scores).reshape(len(C_range), len(gamma_range))

plt.figure(figsize=(8, 6))
plt.subplots_adjust(left=.2, right=0.95, bottom=0.15, top=0.95)
plt.imshow(scores, interpolation='nearest', cmap=plt.cm.hot,
           norm=MidpointNormalize(vmin=0.2, midpoint=0.92))
plt.xlabel('gamma')
plt.ylabel('C')
plt.colorbar()
plt.xticks(np.arange(len(gamma_range)), gamma_range, rotation=45)
plt.yticks(np.arange(len(C_range)), C_range)
plt.title('Validation accuracy')
plt.show()
