import tm_dict
import numpy as np
import pandas as pd
import time

def target_mean_v2(data, y_name, x_name):
    result = np.zeros(data.shape[0])
    value_dict = dict()
    count_dict = dict()
    for i in range(data.shape[0]):
        if data.loc[i, x_name] not in value_dict.keys():
            value_dict[data.loc[i, x_name]] = data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] = 1
        else:
            value_dict[data.loc[i, x_name]] += data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] += 1
    for i in range(data.shape[0]):
        result[i] = (value_dict[data.loc[i, x_name]] - data.loc[i, y_name]) / (count_dict[data.loc[i, x_name]] - 1)
    return result

def main():
    y = np.random.randint(2, size=(5000, 1))
    x = np.random.randint(10, size=(5000, 1))
    data = pd.DataFrame(np.concatenate([y, x], axis=1), columns=['y', 'x'])
    
    # time_start=time.time()
    # result_1 = target_mean_v1(data, 'y', 'x')
    # time_end=time.time()
    # print('v1 cost:',time_end-time_start)

    # time_start=time.time()
    result_2 = target_mean_v2(data, 'y', 'x')
    # time_end=time.time()
    # print('v3 cost:',time_end-time_start)

    time_start=time.time()
    result_4 = tm_dict.target_mean_v3(data, 'y', 'x')
    time_end=time.time()
    print('v4 cost:',time_end-time_start)
    
    diff = np.linalg.norm(result_2 - result_4)
    print(diff)


if __name__ == '__main__':
    main()