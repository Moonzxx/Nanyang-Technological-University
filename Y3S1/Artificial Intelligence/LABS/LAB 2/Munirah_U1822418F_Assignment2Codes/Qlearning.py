import argparse
import random
from environment import TreasureCube
import numpy as np
from collections import defaultdict

import matplotlib
import matplotlib.style
import pandas as pd
import sys

from collections import namedtuple
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

from lib import plotting as pl

#Created Policy class
"""

An epsilon-greedy policy

It returns a function that takes the current state as an input and
returns the probabilities computed for eachaction from the set of
possible actions in current state.

"""

class policy():
    def __init__(self, epsilon, action_space_num):
        self.epsilon = epsilon
        self.nA = action_space_num

    def probs(self,q_table,observation):
        A_probs = np.ones(self.nA, dtype = float) * self.epsilon / self.nA
        best_action = np.argmax(q_table[observation])
        A_probs[best_action] += (1 - self.epsilon)

        return A_probs



#Created Qlearning class
class Qlearning(object):
    def __init__(self, epsilon, discount_factor, alpha):
        self.action_space = ['left','right','forward','backward','up','down']
        # Number of possible actions 
        self.action_space_n = len(self.action_space)
        # Nested Dictionary
        self.q_table = defaultdict(lambda: np.zeros(self.action_space_n))
        self.epsilon = epsilon
        self.discount_factor = discount_factor
        self.alpha = alpha
        # Epsilon Greedy policy function for action space
        self.policy = policy(self.epsilon, self.action_space_n)

        
    # Updates the Q-table to train algorithm
    def train(self, state, action, next_state, reward):
        next_action = np.argmax(self.q_table[next_state])
        td_target = reward + self.discount_factor * self.q_table[next_state][next_action]
        td_error = td_target - self.q_table[state][self.action_space.index(action)]
        self.q_table[state][self.action_space.index(action)] += self.alpha * td_error


    # Action chosen based on the probability distribution of the policy
    #   created for the current state 
    def take_action(self,state):
        A_probs = self.policy.probs(self.q_table,state)
        action = np.random.choice(np.arange(len(A_probs)), p = A_probs)
        return self.action_space[action]

    # Prints the Q-table
    def print_Qtable(self):
        print("--------------------------- Q-table ------------------------------")
        print("         Left        Right      Forward     Backward       Up          Down")
        for state,action in self.q_table.items():
            print("{}, {}".format(state,action))

    
        


def test_cube(max_episode, max_step):
    env = TreasureCube(max_step=max_step)
    agent = Qlearning(0.01, 0.99, 0.5)

    matplotlib.style.use('ggplot')
    
    # Created 'stats' to keep track of the statistics (For graphing purposes)
    stats = pl.EpisodeStats( episode_lengths = np.zeros(max_episode), episode_rewards = np.zeros(max_episode))

    for episode_num in range(0, max_episode):
        # Reset env and pick the first action
        state = env.reset()
        terminate = False
        t = 0
        episode_reward = 0
        while not terminate:
            action = agent.take_action(state)
            # Take action and get reward, transit to next state
            reward, terminate, next_state = env.step(action)

            #Update Episode Stats for graph
            stats.episode_rewards[episode_num] += reward 
            stats.episode_lengths[episode_num] = t
            
            episode_reward += reward
            
            # You can comment the following two lines, if the output is too much
            env.render() # comment
            print(f'step: {t}, action: {action}, reward: {reward}') # comment
            t += 1
            # Train the Q-learning algorithm
            agent.train(state, action, next_state, reward)
            state = next_state
        # Comment the following line to prevent long output
        print(f'epsisode: {episode_num}, total_steps: {t} episode reward: {episode_reward}')

    # Prints out the Q-table once all episodes have been computed
    agent.print_Qtable()
    
    # Printing of graph
    fig1 = plt.figure(figsize=(10,5))
    smoothing_window = 5
    rewards_smoothed = pd.Series(stats.episode_rewards).rolling(smoothing_window, min_periods=smoothing_window).mean()
    plt.plot(rewards_smoothed)
    plt.xlabel("Episode")
    plt.ylabel("Episode Reward (Smoothed)")
    plt.title("Episode Reward over Episode (Smoothed over window size {})".format(smoothing_window))
    plt.show()
    


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Test')
    parser.add_argument('--max_episode', type=int, default=500)
    parser.add_argument('--max_step', type=int, default=500)
    args = parser.parse_args()

    test_cube(args.max_episode, args.max_step)
